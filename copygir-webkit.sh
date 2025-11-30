#!/bin/sh
set -e

TARGET="internal/gir/spec"
mkdir -p "$TARGET"

# WebKit GIR files to generate
WEBKIT_GIRS="WebKit-6.0.gir JavaScriptCore-6.0.gir Soup-3.0.gir"

# Base GIR files needed for type resolution (not generated, only parsed)
BASE_GIRS="GLib-2.0.gir GObject-2.0.gir Gio-2.0.gir Gtk-4.0.gir Gdk-4.0.gir Gsk-4.0.gir Pango-1.0.gir GdkPixbuf-2.0.gir cairo-1.0.gir Graphene-1.0.gir GModule-2.0.gir PangoCairo-1.0.gir"

for f in $WEBKIT_GIRS $BASE_GIRS; do
    echo "Copying $f..."
    flatpak run --filesystem="${PWD}" --command=cp org.gnome.Sdk \
        "/usr/share/gir-1.0/$f" "${PWD}/$TARGET/$f"
done

echo "Done! GIR files copied to $TARGET"
