#!/bin/bash
set -e

# Sync template from local puregotk
cp ../puregotk/templates/go templates/go

echo "Template synced from local ../puregotk"
echo "Run './gen.sh' to regenerate"
