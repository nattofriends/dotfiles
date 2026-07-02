#!/usr/bin/env python3

import fnmatch
import json
import os
import shutil
import platform
import re
import subprocess
import tarfile
import tempfile
from configparser import ConfigParser
from pathlib import Path
from urllib.request import urlopen
from urllib.request import urlretrieve
from zipfile import ZipFile


BIN_DIR = Path("gh-bin")
RELEASE_API = 'https://api.github.com/repos/{}/releases'


def main():
    conf = ConfigParser()
    conf.read('global/ghdl.ini')
    sections = conf.sections()

    if os.path.exists('local/ghdl.ini'):
        conf.read('local/ghdl.ini')
        sections.extend(conf.sections())

    downloaded_versions = {}
    BIN_DIR.mkdir(exist_ok=True)
    versions_path = BIN_DIR / "versions.json"

    if versions_path.exists():
        downloaded_versions = json.loads(versions_path.read_text())

    identifiers = get_identifiers()

    print("Starting ghdl")
    for i, section in enumerate(conf.sections()):
        print(f'{i+1}: Working on {section}')
        repo = conf[section]['repo']
        tag = conf[section]['tag'].format(**identifiers)
        file = conf[section]['file'].format(**identifiers)
        archive_member = conf[section].get('archive_member', section)
        local_name = conf[section].get('local_name', section)

        existing_version = downloaded_versions.get(section)

        downloaded_tag = process(
            repo,
            tag,
            file,
            archive_member,
            local_name,
            existing_version,
        )
        downloaded_versions[section] = downloaded_tag

    versions_path.parent.mkdir(parents=True, exist_ok=True)
    versions_path.write_text(json.dumps(downloaded_versions, indent=2))


def get_identifiers():
    identifiers = {
        'system': platform.system(),
        'machine': platform.machine(),
    }

    if identifiers['machine'] in ('x86_64', 'amd64'):
        identifiers['machine'] = 'x86_64|amd64|64bit'
    elif identifiers['machine'] == "arm64":
        identifiers["machine"] += "|aarch64"
    if identifiers['system'] == 'Darwin':
        identifiers['system'] += '|macOS'

    return {k: f'({v})' for k, v in identifiers.items()}


def process(repo, tag_filter, file_filter, archive_member, local_name, existing_version):
    releases = urlopen(RELEASE_API.format(repo))
    releases = json.load(releases)

    for release in releases:
        if not release['prerelease'] and re.search(tag_filter, release['tag_name'], flags=re.I):
            print(f'Found matching release name: {release["tag_name"]}')
            break

    if release["tag_name"] == existing_version:
        print(f"Skipping {existing_version} which already exists")
        return existing_version

    for asset in release['assets']:
        if re.search(file_filter, asset['name'], flags=re.I):
            print(f'Found matching asset name: {asset["name"]}')
            break

    print(f'Downloading asset URL: {asset["browser_download_url"]}...')

    downloaded, _ = urlretrieve(asset['browser_download_url'])
    target_path = BIN_DIR / local_name

    if asset['name'].endswith('.zip'):
        with ZipFile(downloaded) as zipf:
            filenames = zipf.namelist()
            target_members = fnmatch.filter(filenames, archive_member)
            assert len(target_members) == 1
            target_member = next(iter(target_members))
            target = zipf.read(target_member)

            target_path = BIN_DIR / local_name
            target_path.write_bytes(target)
            target_path.chmod(0o755)
            print(f'Wrote {archive_member} to disk')
    elif asset['name'].endswith('.tar.gz'):
        with tarfile.open(downloaded) as tarf:
            extract_tar_member(tarf, archive_member, target_path)
    elif asset['name'].endswith('.tar.zst'):
        unzstd = shutil.which('unzstd')
        if not unzstd:
            raise RuntimeError('Cannot extract .tar.zst asset: unzstd from zstd(1) was not found')

        with tempfile.TemporaryFile() as f:
            subprocess.run([unzstd, '-c', downloaded], stdout=f, check=True)
            f.seek(0)
            with tarfile.open(fileobj=f, mode='r:') as tarf:
                extract_tar_member(tarf, archive_member, target_path)
    else:
        shutil.move(downloaded, target_path)

    target_path.chmod(0o755)

    return release['tag_name']


def extract_tar_member(tarf, archive_member, target_path):
    filenames = tarf.getnames()
    target_members = fnmatch.filter(filenames, archive_member)
    assert len(target_members) == 1
    target_member = next(iter(target_members))
    target = tarf.extractfile(tarf.getmember(target_member))

    if target_path.exists():
        target_path.unlink()
    target_path.write_bytes(target.read())
    target_path.chmod(0o755)
    print(f'Wrote {target_member} to disk')


if __name__ == '__main__':
    main()
