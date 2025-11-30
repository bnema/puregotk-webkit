package main

import (
	"os"
	"path/filepath"
	"strings"
	"text/template"

	"github.com/jwijenbergh/puregotk/internal/gir/pass"
	"github.com/jwijenbergh/puregotk/internal/gir/types"
	"github.com/jwijenbergh/puregotk/internal/gir/util"
)

//go:generate go run gen.go

// Namespaces to generate (others are for type resolution only)
var localNamespaces = map[string]bool{
	"WebKit":                    true,
	"JavaScriptCore":            true,
	"WebKitWebProcessExtension": true,
	"Soup":                      true,
}

func main() {
	dir := "v4"
	os.RemoveAll(dir)

	var girs []string
	filepath.Walk("internal/gir/spec", func(path string, f os.FileInfo, err error) error {
		if !strings.HasSuffix(path, ".gir") {
			return nil
		}
		girs = append(girs, path)
		return nil
	})

	p, err := pass.New(girs)
	if err != nil {
		panic(err)
	}

	// Collect ALL types for resolution (including base GTK types)
	p.First()

	// Filter to only generate WebKit namespaces
	var filtered []types.Repository
	for _, r := range p.Parsed {
		ns := r.Namespaces[0].Name
		if localNamespaces[ns] {
			filtered = append(filtered, r)
		}
	}
	p.Parsed = filtered

	// Create the template
	gotemp, err := template.New("go").Funcs(template.FuncMap{
		"conv":     util.ConvertArgs,
		"convc":    util.ConvertArgsComma,
		"convcb":   util.ConvertCallbackArgs,
		"convcd":   util.ConvertArgsCommaDeref,
		"convd":    util.ConvertArgsDeref,
		"convcbne": util.ConvertCallbackArgsNoErr,
	}).ParseFiles("templates/go")
	if err != nil {
		panic(err)
	}

	// Write go files by making the second pass
	p.Second(dir, gotemp)
}
