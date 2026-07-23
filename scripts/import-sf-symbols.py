#!/usr/bin/env python3

# Copyright (c) 2022-2025 Jason Morley
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import argparse
import json
import os
import plistlib

SCRIPTS_DIRECTORY = os.path.dirname(os.path.abspath(__file__))
ROOT_DIRECTORY = os.path.dirname(SCRIPTS_DIRECTORY)
RESOURCES_DIRECTORY = os.path.join(ROOT_DIRECTORY, "apple", "Symbolic", "Resources")
SF_SYMBOLS_DIRECTORY = os.path.join(RESOURCES_DIRECTORY, "sf-symbols")

DEFAULT_CORE_GLYPHS = "/System/Library/CoreServices/CoreGlyphs.bundle/Contents/Resources"

LOCALE_SUFFIXES = {
    "ar", "he", "hi", "th", "zh", "ja", "ko", "ru", "el", "bn", "gu", "kn",
    "ml", "mr", "or", "pa", "ta", "te", "si", "km", "my", "lo", "ur", "fa",
}


def load_plist(directory, name):
    with open(os.path.join(directory, name), "rb") as fh:
        return plistlib.load(fh)


def is_localization_variant(name, names):
    """Return True if `name` is a localization variant of another symbol."""
    if name.endswith(".rtl"):
        return True
    suffix = name.rsplit(".", 1)[-1]
    if suffix in LOCALE_SUFFIXES and name[:-(len(suffix) + 1)] in names:
        return True
    return False


def main():
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("resources", nargs="?", default=DEFAULT_CORE_GLYPHS,
                        help="path to the CoreGlyphs bundle resources directory; defaults to the system location")
    options = parser.parse_args()

    order = load_plist(options.resources, "symbol_order.plist")
    availability = load_plist(options.resources, "name_availability.plist")
    aliases = load_plist(options.resources, "name_aliases.strings")

    all_names = set(availability["symbols"].keys())
    year_to_release = availability["year_to_release"]

    def minimum_macos_version(name):
        year = availability["symbols"][name]
        release = year_to_release[year]
        return release["macOS"]

    names = [name for name in order if not is_localization_variant(name, all_names)]
    names_set = set(names)

    symbols = [
        {
            "id": name,
            "variants": {
                "default": {
                    "format": "symbol",
                    "properties": {
                        "name": name,
                        "minimumOperatingSystemVersion": minimum_macos_version(name),
                    },
                },
            },
        }
        for name in names
    ]

    def resolve(name, seen=()):
        if name in names_set:
            return name
        if name in aliases and name not in seen:
            return resolve(aliases[name], seen + (name,))
        return None

    resolved_aliases = {}
    for old_name in sorted(aliases.keys()):
        if old_name in names_set:
            continue
        if is_localization_variant(old_name, all_names):
            continue
        canonical = resolve(old_name)
        if canonical is not None:
            resolved_aliases[old_name] = canonical

    manifest = {
        "id": "sf-symbols",
        "name": "SF Symbols",
        "author": "Apple Inc",
        "url": "https://developer.apple.com/sf-symbols/",
        "license": {
            "name": "Agreements and Guidelines",
            "url": "https://developer.apple.com/support/terms/",
        },
        "warning": ("Apple sets out specific guidelines defining acceptable use of SF Symbols and explicitly "
                    "prohibits their use in icons.\n\nEnsure you only use exported files containing SF Symbols in "
                    "ways permitted under the relevant terms and conditions."),
        "symbols": symbols,
        "aliases": resolved_aliases,
    }

    os.makedirs(SF_SYMBOLS_DIRECTORY, exist_ok=True)
    with open(os.path.join(SF_SYMBOLS_DIRECTORY, "manifest.json"), "w") as fh:
        json.dump(manifest, fh, indent=2)
        fh.write("\n")

    print("Imported %d SF Symbols (%d aliases)." % (len(symbols), len(resolved_aliases)))


if __name__ == "__main__":
    main()
