#!/usr/bin/env python3
import os.path
import sys
from configparser import ConfigParser


def main():
    root = sys.argv[1]

    contents = os.listdir(root)

    for file in contents:
        full_file = os.path.join(root, file)
        if os.path.islink(full_file):
            os.remove(full_file)

    conf = ConfigParser(allow_no_value=True)
    conf.read('global/metapath.ini')

    confs = [conf]

    for conf in confs:
        for section in conf.sections():
            if section.startswith("include"):
                _, include_path = section.split(" ", maxsplit=1)
                include_path = os.path.expandvars(os.path.expanduser(include_path))
                subconf = ConfigParser(allow_no_value=True)
                subconf.read(include_path)
                confs.append(subconf)

            else:
                source_dir = os.path.expandvars(os.path.expanduser(section))
                if not os.path.exists(source_dir):
                    print(f"WARNING: Skipping source directory {source_dir} which does not exist")
                    continue

                for item in conf[section]:
                    if item.startswith("@"):
                        item = item[1:]
                        dest = os.path.join(source_dir, item)
                        fn = os.path.join(root, item)
                        with open(fn, 'w') as fh:
                            fh.write(f'exec {dest} "$@"')
                        os.chmod(fn, 0o755)
                    else:
                        os.symlink(
                            os.path.join(source_dir, item),
                            os.path.join(root, item),
                        )


if __name__ == '__main__':
    main()
