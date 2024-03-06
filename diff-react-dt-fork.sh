#!/bin/bash -e

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
BASELINE_PATH="$SCRIPT_PATH"/diff-baseline.diff

echo "Creating diff baseline at $BASELINE_PATH"

> "$BASELINE_PATH"

for file in $(find types/react -type d \( -name "v*" -o -name "node_modules" -prune \) -o -type f -print); do
  rel_path=${file#types/react/}
  if [ -f "types/react/ts5.0/$rel_path" ]; then
    diff -u "$file" "types/react/ts5.0/$rel_path" >> "$BASELINE_PATH" || true
  fi
done