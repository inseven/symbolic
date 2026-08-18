#!/usr/bin/env python3

import argparse
import json
import os
import shutil

SCRIPTS_DIRECTORY = os.path.dirname(os.path.abspath(__file__))
ROOT_DIRECOTRY = os.path.dirname(SCRIPTS_DIRECTORY)
RESOURCES_DIRECTORY = os.path.join(ROOT_DIRECOTRY, "apple", "Symbolic", "Resources")

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
            "name": "Apache License, Version 2.0",
            "path": "LICENSE",
            "url": "https://www.apache.org/licenses/LICENSE-2.0.html"
        },
        "variants": [
            {
                "id": "default",
                "name": "Filled",
            },
            {
                "id": "outlined",
                "name": "Outlined",
            },
            {
                "id": "round",
                "name": "Rounded",
            },
            {
                "id": "sharp",
                "name": "Sharp",
            },
            {
                "id": "twotone",
                "name": "Two Tone",
            },
        ],
        "symbols": [],
    }

    variant_keys = [variant["id"] for variant in manifest["variants"]]

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
                "variants": []
            }

            icon_base_path = os.path.join(category_path, icon)

            # The directory listing is in filesystem order, so index the variants by identifier and emit them in the
            # order the manifest declares them; the manifest is the source of truth for variant ordering.
            directories = {}
            for variant in os.listdir(icon_base_path):
                assert variant.startswith("materialicons")
                variant_name = variant[len("materialicons"):]
                variant_key = variant_name if variant_name else "default"
                if variant_key not in variant_keys:
                    exit("Variant '%s' not defined in manfiest." % variant_key)
                directories[variant_key] = variant

            for variant_key in variant_keys:
                if variant_key not in directories:
                    continue
                icon_path = os.path.join(icon_base_path, directories[variant_key], "24px.svg")
                basename = "%s.%s.svg" % (icon, variant_key)
                shutil.copyfile(icon_path, os.path.join(MATERIAL_ICONS_DIRECTORY, basename))
                symbol["variants"].append({
                    "id": variant_key,
                    "format": "svg",
                    "properties": {
                        "path": basename
                    }
                })
            manifest["symbols"].append(symbol)

    with open(os.path.join(MATERIAL_ICONS_DIRECTORY, "manifest.json"), "w") as fh:
        json.dump(manifest, fh, indent=4)


if __name__ == "__main__":
    main()
