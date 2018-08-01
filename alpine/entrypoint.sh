#!/usr/bin/env sh

if [ "$1" = "cast" ]; then
	SRC_FLAG=
	SRC=

	for arg in "$@"; do
		if [ -n "$SRC_FLAG" ]; then
			SRC=$arg
			break
		elif [ "$arg" = "--sourceDir" ]; then
			SRC_FLAG=true
		fi
	done

	TMP=
	DIALOG=

	if [ -d "$SRC/tmp" ]; then
		TMP=$(mktemp -p "$SRC" -u tmp.XXXXXX)
		mv "$SRC/tmp" "$TMP"
	fi
	if [ -d "$SRC/dialog" ]; then
		DIALOG=$(mktemp -p "$SRC" -u dialog.XXXXXX)
		mv "$SRC/dialog" "$DIALOG"
	fi

	shift
	java -jar HighlightAutomation.jar "$@"

	rm -rf "$SRC/tmp"
	test -n "$TMP" && mv "$TMP" "$SRC/tmp"

	rm -rf "$SRC/dialog"
	test -n "$DIALOG" && mv "$DIALOG" "$SRC/dialog"

	exit
fi

exec "$@"
