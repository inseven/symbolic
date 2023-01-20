#!/usr/bin/env python3

import argparse
import json
import os
import shutil

SCRIPTS_DIRECTORY = os.path.dirname(os.path.abspath(__file__))
ROOT_DIRECOTRY = os.path.dirname(SCRIPTS_DIRECTORY)
RESOURCES_DIRECTORY = os.path.join(ROOT_DIRECOTRY, "Symbolic", "Resources")

MATERIAL_ICONS_DIRECTORY = os.path.join(RESOURCES_DIRECTORY, "material-icons")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("repository")
    options = parser.parse_args()

    manifest = {
        "id": "material-icons",
        "name": "Material Icons",
        "url": "https://fonts.google.com/icons",
        "author": "Google",
        "license": {
            "path": "LICENSE",
            "url": "https://www.apache.org/licenses/LICENSE-2.0.html"
        },
        "variants": {
            "default": {
                "name": "Default",
            },
            "outlined": {
                "name": "Outlined"
            },
            "twotone": {
                "name": "Two Tone",
            },
            "round": {
                "name": "Round",
            },
            "sharp": {
                "name": "Sharp",
            },
        },
        "symbols": [],
    }

    repository_directory = os.path.abspath(options.repository)
    license_path = os.path.join(repository_directory, "LICENSE")
    shutil.copy(license_path, MATERIAL_ICONS_DIRECTORY)

    src_directory = os.path.join(repository_directory, "src")
    categories = os.listdir(src_directory)
    for category in categories:
        category_path = os.path.join(src_directory, category)
        icons = os.listdir(category_path)
        for icon in icons:
            print("Importing '%s'..." % icon)
            symbol = {
                "id": icon,
                "name": icon.replace("_", " ").title(),
                "variants": {}
            }

            icon_base_path = os.path.join(category_path, icon)
            variants = os.listdir(icon_base_path)

            for variant in variants:
                assert variant.startswith("materialicons")
                variant_name = variant[len("materialicons"):]
                variant_key = variant_name if variant_name else "default"
                if variant_key not in manifest["variants"]:
                    exit("Variant '%s' not defined in manfiest." % variant_key)
                icon_path = os.path.join(category_path, icon, variant, "24px.svg")
                basename = "%s.%s.svg" % (icon, variant_key)
                shutil.copyfile(icon_path, os.path.join(MATERIAL_ICONS_DIRECTORY, basename))
                symbol["variants"][variant_key] = {
                    "path": basename
                }
            manifest["symbols"].append(symbol)

    with open(os.path.join(MATERIAL_ICONS_DIRECTORY, "manifest.json"), "w") as fh:
        json.dump(manifest, fh, indent=4)


if __name__ == "__main__":
    main()