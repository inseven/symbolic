#!/usr/bin/env python3

# Copyright (c) 2022-2026 Jason Morley
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
import re
import urllib.request

SCRIPTS_DIRECTORY = os.path.dirname(os.path.abspath(__file__))
ROOT_DIRECTORY = os.path.dirname(SCRIPTS_DIRECTORY)
RESOURCES_DIRECTORY = os.path.join(ROOT_DIRECTORY, "apple", "Symbolic", "Resources")
EMOJI_DIRECTORY = os.path.join(RESOURCES_DIRECTORY, "emoji")

DEFAULT_EMOJI_TEST = "https://www.unicode.org/Public/emoji/latest/emoji-test.txt"

# Emoji 15.1  macOS 14.4   5 March 2024     https://blog.emojipedia.org/ios-17-4-emoji-changelog/
# Emoji 16.0  macOS 15.4   31 March 2025    https://blog.emojipedia.org/apple-ios-18-4-emoji-changelog/
# Emoji 17.0  macOS 26.4   24 March 2026    https://blog.emojipedia.org/apple-ios-26-4-emoji-changelog/
# N.B. `None` denotes versions shipped prior to the minimum macOS version supported by Symbolic.
EMOJI_AVAILABILITY = {
    "0.6": None,
    "0.7": None,
    "1.0": None,
    "2.0": None,
    "3.0": None,
    "4.0": None,
    "5.0": None,
    "11.0": None,
    "12.0": None,
    "12.1": None,
    "13.0": None,
    "13.1": None,
    "14.0": None,
    "15.0": None,
    "15.1": "14.4",
    "16.0": "15.4",
    "17.0": "26.4",
}

# e.g. '1F44B 1F3FB ; fully-qualified # 👋🏻 E1.0 waving hand: light skin tone'
ENTRY_EXPRESSION = re.compile(r"^(?P<codepoints>[0-9A-F][0-9A-F ]*?)\s*;\s*"
                              r"(?P<status>[a-z-]+)\s*#\s*"
                              r"(?P<character>\S+)\s+"
                              r"E(?P<version>[0-9]+\.[0-9]+)\s+"
                              r"(?P<name>.+)$")

SKIN_TONE_EXPRESSION = re.compile(r"\b(light|medium-light|medium|medium-dark|dark) skin tone\b")


def read_emoji_test(path):
    """Return the contents of emoji-test.txt, fetching it over the network if given a URL."""
    if path.startswith("https://") or path.startswith("http://"):
        with urllib.request.urlopen(path) as response:
            return response.read().decode("utf-8")
    with open(path, encoding="utf-8") as fh:
        return fh.read()


def data_version(contents):
    """Return the Emoji version the data file declares."""
    match = re.search(r"^#\s*Version:\s*(?P<version>[0-9.]+)\s*$", contents, re.MULTILINE)
    if match is None:
        exit("Unable to determine the version of the emoji data.")
    return match.group("version")


def version_components(version):
    return tuple(int(component) for component in version.split("."))


def minimum_macos_version(version, name):
    if version not in EMOJI_AVAILABILITY:
        # Failing here is deliberate: silently importing an emoji we don't have a gate for would ship symbols that
        # render as blank boxes on the macOS releases whose font predates them.
        exit("Emoji version 'E%s' (first seen on '%s') has no known macOS release; update EMOJI_AVAILABILITY." %
             (version, name))
    return EMOJI_AVAILABILITY[version]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("emoji_test", nargs="?", default=DEFAULT_EMOJI_TEST,
                        help="path or URL of the Unicode emoji-test.txt data file; defaults to the latest published")
    options = parser.parse_args()

    contents = read_emoji_test(options.emoji_test)
    version = data_version(contents)

    symbols = []
    skipped_skin_tones = 0
    for line in contents.splitlines():
        match = ENTRY_EXPRESSION.match(line.strip())
        if match is None:
            continue

        # 'component' entries are the modifiers themselves (the skin tone swatches and hair components) and the
        # unqualified forms are duplicates of the fully-qualified sequences.
        if match.group("status") != "fully-qualified":
            continue

        name = match.group("name")
        if SKIN_TONE_EXPRESSION.search(name):
            skipped_skin_tones += 1
            continue

        # The codepoint sequence is the emoji's stable identity; names are editorial and Unicode do revise them.
        identifier = "-".join(codepoint.lower() for codepoint in match.group("codepoints").split())

        symbols.append({
            "id": identifier,
            "name": name[0].upper() + name[1:],
            "variants": [
                {
                    "id": "default",
                    "format": "emoji",
                    "properties": {
                        "character": match.group("character"),
                        "minimumOperatingSystemVersion": minimum_macos_version(match.group("version"), name),
                    },
                },
            ],
        })

    identifiers = [symbol["id"] for symbol in symbols]
    if len(identifiers) != len(set(identifiers)):
        exit("Duplicate emoji identifiers in the generated manifest.")

    manifest = {
        "id": "emoji",
        "name": "Emoji",
        "author": "Apple Inc",
        "url": "https://unicode.org/emoji/",
        "license": {
            "name": "Agreements and Guidelines",
            "url": "https://developer.apple.com/support/terms/",
        },
        "warning": ("Emoji are rendered using the system font and are copyright Apple Inc.\n\n"
                    "Ensure you only use exported files containing emoji in ways permitted under the relevant terms "
                    "and conditions."),
        "symbols": symbols,
    }

    os.makedirs(EMOJI_DIRECTORY, exist_ok=True)
    with open(os.path.join(EMOJI_DIRECTORY, "manifest.json"), "w", encoding="utf-8") as fh:
        json.dump(manifest, fh, indent=2, ensure_ascii=False)
        fh.write("\n")

    gated = len([symbol for symbol in symbols
                 if symbol["variants"][0]["properties"]["minimumOperatingSystemVersion"] is not None])
    print("Imported %d emoji from Emoji %s (%d gated by macOS version, %d skin tone variations skipped)." %
          (len(symbols), version, gated, skipped_skin_tones))


if __name__ == "__main__":
    main()
