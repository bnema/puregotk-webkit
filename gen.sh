#!/usr/bin/env bash
set -e

echo "Generating Go files..."
go run gen.go

echo "Running goimports..."
goimports -w v4

echo "Formatting..."
go fmt ./v4/...

echo "Vetting..."
go vet ./v4/...

echo "Done!"
