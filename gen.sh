#!/usr/bin/env bash
set -e

echo "Generating Go files..."
go run gen.go

PKGS="webkit javascriptcore soup webkitwebprocessextension"

echo "Running goimports..."
for pkg in $PKGS; do [ -d "$pkg" ] && goimports -w "$pkg"; done

echo "Formatting..."
for pkg in $PKGS; do [ -d "$pkg" ] && go fmt ./"$pkg"/...; done

echo "Vetting..."
for pkg in $PKGS; do [ -d "$pkg" ] && go vet ./"$pkg"/...; done

echo "Done!"
