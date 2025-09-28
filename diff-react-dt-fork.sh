#!/bin/bash -e

VERSION=${1:-"latest"}
case "$VERSION" in
 latest) TYPES_PATH="types/react" ;;
 *) TYPES_PATH="types/react/$VERSION" ;;
esac

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
BASELINE_PATH="$SCRIPT_PATH"/diff-baseline-$VERSION.diff

echo "Creating diff baseline at $BASELINE_PATH"

> "$BASELINE_PATH"

for file in $(find "$TYPES_PATH/" -type d \( -name "v*" -o -name "node_modules" -prune \) -o -type f -print); do
  rel_path=${file#"$TYPES_PATH/"}
  if [ -f "$TYPES_PATH/ts5.0/$rel_path" ]; then
    # Strip timestamps from --- and +++ lines using awk (prints only first two fields)
    diff -u "$file" "$TYPES_PATH/ts5.0/$rel_path" \
      | awk '{if ($1=="---"||$1=="+++") print $1, $2; else print $0}' >> "$BASELINE_PATH" || true
  fi
done