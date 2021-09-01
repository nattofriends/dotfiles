#!/usr/bin/python3

from configparser import ConfigParser
import os.path
import sys


def main():
    root = sys.path[0]

    contents = os.listdir(root)

    for file in contents:
        full_file = os.path.join(root, file)
        if os.path.islink(full_file):
            os.remove(full_file)

    conf = ConfigParser(allow_no_value=True)
    conf.read('manifest.ini')

    for section in conf.sections():
        source_dir = os.path.expandvars(os.path.expanduser(section))
        assert os.path.exists(source_dir)

        for item in conf[section]:
            os.symlink(
                os.path.join(source_dir, item),
                os.path.join(root, item),
            )


if __name__ == '__main__':
    main()
