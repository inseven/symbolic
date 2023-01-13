#!/usr/bin/env python3

import argparse
import os
import shutil

SCRIPTS_DIRECTORY = os.path.dirname(os.path.abspath(__file__))
ROOT_DIRECOTRY = os.path.dirname(SCRIPTS_DIRECTORY)
RESOURCES_DIRECTORY = os.path.join(ROOT_DIRECOTRY, "Symbolic", "Resources", "Material Design")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("src")
    options = parser.parse_args()

    src_directory = os.path.abspath(options.src)
    categories = os.listdir(src_directory)
    print(categories)
    for category in categories:
        category_path = os.path.join(src_directory, category)
        icons = os.listdir(category_path)
        for icon in icons:
            icon_path = os.path.join(category_path, icon, "materialicons", "24px.svg")
            if os.path.exists(icon_path):
                shutil.copyfile(icon_path, os.path.join(RESOURCES_DIRECTORY, "%s.svg" % icon))
            else:
                print(icon_path)
            outlined_icon_path = os.path.join(category_path, icon, "materialiconsoutlined", "24px.svg")
            if os.path.exists(outlined_icon_path):
                shutil.copyfile(outlined_icon_path, os.path.join(RESOURCES_DIRECTORY, "%s-outlined.svg" % icon))
            else:
                print(icon_path)


if __name__ == "__main__":
    main()