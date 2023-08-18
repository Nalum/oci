package main

artifacts: [
	{
		name:           "nalum/oci/base"
		source:         "git@github.com:nalum/oci.git"
		targetRegistry: "ghcr.io"
		artifactRoot:   "./base"
	},
	{
		name:           "nalum/oci/pod-info-root"
		source:         "git@github.com:stefanprodan/podinfo.git"
		targetRegistry: "ghcr.io"
		artifactRoot:   "./kustomize"
		annotations: [
			{
				name:  "author"
				value: "stefanprodan"
			},
			{
				name:  "packager"
				value: "nalum"
			},
		]
	},
	{
		name:           "nalum/oci/pod-info-paths"
		source:         "git@github.com:stefanprodan/podinfo.git"
		targetRegistry: "ghcr.io"
		includePaths: [
			"kustomize",
		]
		annotations: [
			{
				name:  "author"
				value: "stefanprodan"
			},
			{
				name:  "packager"
				value: "nalum"
			},
		]
	},
]
