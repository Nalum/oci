package templates

import (
	scv1beta2 "github.com/fluxcd/source-controller/api/v1beta2"
)

#OCIRepository: scv1beta2.#OCIRepository & {
	_config:    #Config
	apiVersion: "source.toolkit.fluxcd.io/v1beta2"
	kind:       "OCIRepository"
	metadata:   _config.metadata
}
