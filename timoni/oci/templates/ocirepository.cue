package templates

import (
	scv1beta2 "github.com/fluxcd/source-controller/api/v1beta2"
)

#OCIRepository: scv1beta2.#OCIRepository & {
	_config:    #Config
	_artifact:  #Artifact
	apiVersion: "source.toolkit.fluxcd.io/v1beta2"
	kind:       "OCIRepository"
	metadata: name:        "\(_artifact.name)-or"
	metadata: namespace:   _config.metadata.namespace
	metadata: labels:      _config.metadata.labels
	metadata: annotations: _config.metadata.annotations
}
