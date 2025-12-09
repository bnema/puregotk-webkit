.PHONY: sync generate build clean

# Sync template from puregotk fork
sync:
	./sync-puregotk.sh

# Generate Go bindings
generate:
	go generate
	goimports -w javascriptcore/ soup/ webkit/ webkitwebprocessextension/

# Build all packages
build:
	go build ./...

# Full sync and regenerate
all: sync generate build

# Clean generated packages
clean:
	rm -rf javascriptcore/ soup/ webkit/ webkitwebprocessextension/
