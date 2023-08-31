package templates

import (
	"strings"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	//scv1beta2 "github.com/fluxcd/source-controller/api/v1beta2"
)

// Config defines the schema and defaults for the Instance values.
#Config: {
	// Metadata (common to all resources)
	metadata: metav1.#ObjectMeta
	metadata: name:      string & =~"^(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" & strings.MaxRunes(63)
	metadata: namespace: string & strings.MaxRunes(63)

	clusterName:     string
	environmentName: string
	regionName:      string

	artifacts: [...#Artifact & {_clusterName: clusterName, _environmentName: environmentName, _regionName: regionName}]
}

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: #Config

	objects: {[string]: _}
	for a in config.artifacts {
		if a.enabled {
			objects: "\(a.name)-or": #OCIRepository & {_config: config & {metadata: name: "\(a.name)-or"}}
			objects: "\(a.name)-k":  #Kustomization & {_config: config & {metadata: name: "\(a.name)-k"}}
		}
	}
}

#Artifact: {
	name:     string
	artifact: string
	registry: string
	source: interval:    *"5m0s" | string
	kustomize: interval: *"1m0s" | string
	kustomize: path:     *"./" | string

	enabledClusters: [...string]
	enabledEnvironments: [...string]
	enabledRegions: [...string]

	promotion: type: *"standard" | "custom"
	promotion: versioning: [...#PromotionCustom]

	// Logic checks for enabling resources
	enabled:             *false | bool
	_clusterEnabled:     *false | bool // Default to false if enabledClusters is set
	_environmentEnabled: *false | bool // Default to false if enabledEnvironments is set
	_regionEnabled:      *false | bool // Default to false if enabledRegions is set
	_clusterName:        string
	_environmentName:    string
	_regionName:         string

	if enabledClusters != [] {
		for c in enabledClusters {
			if c == _clusterName {
				_clusterEnabled: true
			}
		}
	}

	if enabledClusters == [] {
		_clusterEnabled: true
	}

	if enabledEnvironments != [] {
		for e in enabledEnvironments {
			if e == _environmentName {
				_environmentEnabled: true
			}
		}
	}

	if enabledEnvironments == [] {
		_environmentEnabled: true
	}

	if enabledRegions != [] {
		for r in enabledRegions {
			if r == _regionName {
				_regionEnabled: true
			}
		}
	}

	if enabledRegions == [] {
		_regionEnabled: true
	}

	if _clusterEnabled && _environmentEnabled && _regionEnabled {
		enabled: true
	}
}

#PromotionCustom: {
	clusters: [...string]
	tag: string
}
