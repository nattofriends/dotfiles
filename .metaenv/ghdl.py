#!/usr/bin/env python3

import json
import os
import platform
import re
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

    for section in conf.sections():
        print(f'Working on {section}')
        repo = conf[section]['repo']
        tag = conf[section]['tag'].format(**identifiers)
        file = conf[section]['file'].format(**identifiers)
        # I hope no one needs renaming
        archive_member = conf[section]['archive_member']

        existing_version = downloaded_versions.get(section)

        downloaded_tag = process(repo, tag, file, archive_member, existing_version)
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
    if identifiers['system'] == 'Darwin':
        identifiers['system'] += '|macOS'

    return {k: f'({v})' for k, v in identifiers.items()}


def process(repo, tag_filter, file_filter, archive_member, existing_version):
    releases = urlopen(RELEASE_API.format(repo))
    releases = json.load(releases)

    for release in releases:
        if re.search(tag_filter, release['tag_name'], flags=re.I):
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

    if asset['name'].endswith('.zip'):
        with ZipFile(downloaded) as zipf:
            target = zipf.read(archive_member)

            target_path = BIN_DIR / archive_member
            target_path.write_bytes(target)
            target_path.chmod(0o755)
            print(f'Wrote {archive_member} to disk')

    return release['tag_name']


if __name__ == '__main__':
    main()
