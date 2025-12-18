#!/bin/bash
set -e

# Sync template from puregotk fork
curl -sL https://raw.githubusercontent.com/bnema/puregotk/dev/templates/go -o templates/go

echo "Template synced from bnema/puregotk"
echo "Run 'go generate && goimports -w .' to regenerate"
