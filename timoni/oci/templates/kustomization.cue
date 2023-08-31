package templates

import (
	kv1 "github.com/fluxcd/kustomize-controller/api/v1"
)

#Kustomization: kv1.#Kustomization & {
	_config:    #Config
	_artifact:  #Artifact
	apiVersion: "kustomize.toolkit.fluxcd.io/v1"
	kind:       "Kustomization"
	metadata: name:        "\(_artifact.name)-k"
	metadata: namespace:   _config.metadata.namespace
	metadata: labels:      _config.metadata.labels
	metadata: annotations: _config.metadata.annotations
	spec: path:            _artifact.kustomize.path
	spec: interval:        _artifact.kustomize.interval
	spec: prune:           false
	spec: sourceRef: kind: "OCIRepository"
	spec: sourceRef: name: "\(_artifact.name)-or"
}
