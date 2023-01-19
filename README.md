# Symbolic

[![build](https://github.com/inseven/symbolic/actions/workflows/build.yaml/badge.svg)](https://github.com/inseven/symbolic/actions/workflows/build.yaml) [![update-release-notes](https://github.com/inseven/symbolic/actions/workflows/update-release-notes.yaml/badge.svg)](https://github.com/inseven/symbolic/actions/workflows/update-release-notes.yaml) [![pages-build-deployment](https://github.com/inseven/symbolic/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/inseven/symbolic/actions/workflows/pages/pages-build-deployment)

Icon designer

<img src="screenshots/main.png" width="1012" />

## Development

Symbolic follows the version numbering, build and signing conventions for InSeven Limited apps. Further details can be found [here](https://github.com/inseven/build-documentation).

## Symbols

### Material Icons

Symbolic includes [Google Material Icons](https://fonts.google.com/icons) which are licensed under the [Apache License](https://www.apache.org/licenses/LICENSE-2.0.html).

Instead of using a submodule, the have been imported into the project using `scripts/import-material-design-icons.py` as the Material Icons repository is about 16GB and including this would significantly impact checkout and build times.

Update the icons as follows:

```bash
scripts/import-material-design-icons.py ~/Projects/material-design-icons	
```

## Licensing

Symbolic is licensed under the MIT License (see [LICENSE](LICENSE)).
