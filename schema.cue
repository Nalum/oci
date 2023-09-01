package main

artifacts: [..._artifact]

_artifact: {
	name!:           string
	source!:         string
	targetRegistry!: string
	targetRef:       *"main" | string
	artifactRoot:    *"./" | string
	includePaths?: [...string]
	annotations?: [..._annotation]
}

_annotation: {
	name!:  string
	value!: string
}
