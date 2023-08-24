package main

artifacts: [
	{
		name:           "nalum/oci/base"
		source:         "git@github.com:nalum/oci.git"
		targetRegistry: "ghcr.io"
		artifactRoot:   "./base"
		annotations: [
			{
				name:  "org.opencontainers.image.source"
				value: "https://github.com/nalum/oci"
			},
			{
				name:  "org.opencontainers.image.authors"
				value: "nalum"
			},
		]
	},
	{
		name:           "nalum/oci/pod-info-root"
		source:         "git@github.com:stefanprodan/podinfo.git"
		targetRegistry: "ghcr.io"
		targetRef:      "master"
		artifactRoot:   "./kustomize"
		annotations: [
			{
				name:  "org.opencontainers.image.authors"
				value: "stefanprodan"
			},
			{
				name:  "org.opencontainers.image.source"
				value: "https://github.com/nalum/oci"
			},
		]
	},
	{
		name:           "nalum/oci/pod-info-paths"
		source:         "git@github.com:stefanprodan/podinfo.git"
		targetRegistry: "ghcr.io"
		targetRef:      "v5.x"
		includePaths: [
			"kustomize",
		]
		annotations: [
			{
				name:  "org.opencontainers.image.authors"
				value: "stefanprodan"
			},
			{
				name:  "org.opencontainers.image.source"
				value: "https://github.com/nalum/oci"
			},
		]
	},
]
