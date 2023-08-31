package templates

import (
	kv1 "github.com/fluxcd/kustomize-controller/api/v1"
)

#Kustomization: kv1.#Kustomization & {
	_config:    #Config
	apiVersion: "kustomize.toolkit.fluxcd.io/v1"
	kind:       "Kustomization"
	metadata:   _config.metadata
}
