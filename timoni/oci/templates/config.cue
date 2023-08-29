package templates

import (
	"strings"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	v1beta2 "github.com/fluxcd/source-controller/api/v1beta2"
)

// Config defines the schema and defaults for the Instance values.
#Config: {
	// Metadata (common to all resources)
	metadata: metav1.#ObjectMeta
	metadata: name:      string & =~"^(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" & strings.MaxRunes(63)
	metadata: namespace: string & strings.MaxRunes(63)
	metadata: labels?: {[ string]: string}
	metadata: annotations?: {[ string]: string}

	clusterName:     string
	environmentName: string
	regionName:      string

	artifacts: [...#Artifact]
}

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: #Config

	objects: {
		for a in config.artifacts {
			if a._enabled {
				"\(a.name)-or": #OCIRepository & {_config: config}
				"\(a.name)-k":  #Kustomization & {_config: config}
			}
		}
	}
}

#Artifact: {
	name!:     string
	registry!: string
	path:      *"./" | string
	ref:       v1beta2.#OCIRepositoryRef

	enabledClusters: [...string]
	disabledClusters: [...string]
	enabledEnvironments: [...string]
	disabledEnvironments: [...string]
	enabledRegions: [...string]
	disabledRegions: [...string]

	// Logic checks for enabling resources
	_enabled:            *false | bool
	_clusterEnabled:     *false | bool
	_environmentEnabled: *false | bool
	_regionEnabled:      *false | bool

	if enabledClusters != [] {
		for c in enabledClusters {
			if c == clusterName {
				_clusterEnabled: true
			}
		}
	}

	if disabledClusters != [] {
		for c in disabledClusters {
			if c == clusterName {
				_clusterEnabled: false
			}
		}
	}

	if disabledClusters == [] && enabledClusters == [] {
		_clusterEnabled: true
	}

	if enabledEnvironments != [] {
		for e in enabledEnvironments {
			if e == environmentName {
				_environmentEnabled: true
			}
		}
	}

	if disabledEnvironments != [] {
		for e in disabledEnvironments {
			if e == environmentName {
				_environmentEnabled: false
			}
		}
	}

	if disabledEnvironments == [] && enabledEnvironments == [] {
		_environmentEnabled: true
	}

	if enabledRegions != [] {
		for r in enabledRegions {
			if r == regionName {
				_regionEnabled: true
			}
		}
	}

	if disabledRegions != [] {
		for r in disabledRegions {
			if r == regionName {
				_regionEnabled: false
			}
		}
	}

	if disabledRegions == [] && enabledRegions == [] {
		_regionEnabled: true
	}

	if _clusterEnabled && _environmentEnabled && _regionEnabled {
		_enabled: true
	}
}
