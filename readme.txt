Header 42

Screenshot in located in file: screenshot.png.

Prepend School 42 header to files.

File may contain something, be empty or not exist at all.

Customize ``who'' and ``domain'' variables in file.sh to suit you needs.

Run ``sh check.sh'' to launch shellcheck.

Usage: header_42 path ...

Installation option

	Create a script called ``header_42'' somewhere in you path the with following content:
		#!/usr/bin/env sh
		exec sh path/to/this/file.sh "$@"

	Run ``chmod +x path/to/header_42''.

License: MIT.

Bugs: since this script is not self-contained, it's hard to install.
