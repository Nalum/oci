package main

import (
	"text/tabwriter"
	"tool/cli"
	"tool/exec"
	"strings"
)

command: ls: {
	task: print: cli.Print & {
		text: tabwriter.Write([
			"OCI Artifact  \tGit Repository  \tArtifact Root  \tInclude Paths  \tAnnotations",
			for x in artifacts {
				"\(x.targetRegistry)/\(x.name)  \t\(x.source)  \t\(x.artifactRoot)  \t\(strings.Join(x.includePaths, ","))  \t\(strings.Join([ for y in x.annotations {"\(y.name)=\(y.value)"}], ","))"
			},
		])
	}
}
