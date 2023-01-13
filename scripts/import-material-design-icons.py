#!/usr/bin/env python3

import argparse
import json
import os
import shutil

SCRIPTS_DIRECTORY = os.path.dirname(os.path.abspath(__file__))
ROOT_DIRECOTRY = os.path.dirname(SCRIPTS_DIRECTORY)
RESOURCES_DIRECTORY = os.path.join(ROOT_DIRECOTRY, "Symbolic", "Resources")

MATERIAL_ICONS_DIRECTORY = os.path.join(RESOURCES_DIRECTORY, "Material Icons")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("src")
    options = parser.parse_args()

    manifest = {}
    manifest["id"] = "material-icons"
    manifest["name"] = "Material Icons"
    manifest["symbols"] = []

    src_directory = os.path.abspath(options.src)
    categories = os.listdir(src_directory)
    for category in categories:
        category_path = os.path.join(src_directory, category)
        icons = os.listdir(category_path)
        for icon in icons:
            symbol = {
                "name": icon.replace("_", " ").title(),
                "variants": {}
            }
            icon_path = os.path.join(category_path, icon, "materialicons", "24px.svg")
            if os.path.exists(icon_path):
                basename = "%s.svg" % icon
                shutil.copyfile(icon_path, os.path.join(MATERIAL_ICONS_DIRECTORY, basename))
                symbol["variants"]["default"] = {
                    "path": basename
                }
            else:
                print(icon_path)
            outlined_icon_path = os.path.join(category_path, icon, "materialiconsoutlined", "24px.svg")
            if os.path.exists(outlined_icon_path):
                shutil.copyfile(outlined_icon_path, os.path.join(MATERIAL_ICONS_DIRECTORY, "%s-outlined.svg" % icon))
            else:
                print(icon_path)
            manifest["symbols"].append(symbol)

    with open(os.path.join(MATERIAL_ICONS_DIRECTORY, "manifest.json"), "w") as fh:
        json.dump(manifest, fh, indent=4)


if __name__ == "__main__":
    main()