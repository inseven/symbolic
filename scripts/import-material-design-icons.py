#!/usr/bin/env python3

# “Commons Clause” License Condition v1.0
#
# The Software is provided to you by the Licensor under the License, as defined
# below, subject to the following condition.
#
# Without limiting other conditions in the License, the grant of rights under the
# License will not include, and the License does not grant to you, the right to
# Sell the Software.
#
# For purposes of the foregoing, “Sell” means practicing any or all of the rights
# granted to you under the License to provide to third parties, for a fee or other
# consideration (including without limitation fees for hosting or consulting/
# support services related to the Software), a product or service whose value
# derives, entirely or substantially, from the functionality of the Software. Any
# license notice or attribution required by the License must also include this
# Commons Clause License Condition notice.
#
# Software: Symbolic
# License: BSD 3-Clause License
# Licensor: InSeven Limited
#
# ---
#
# BSD 3-Clause License
#
# Copyright (c) 2022-2023 InSeven Limited
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
            "name": "Apache License, Version 2.0",
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