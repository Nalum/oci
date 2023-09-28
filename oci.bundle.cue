package main

bundle: {
	_clusterName:     string @timoni(runtime:string:CLUSTER_NAME)
	_environmentName: string @timoni(runtime:string:ENVIRONMENT_NAME)
	_regionName:      string @timoni(runtime:string:REGION_NAME)

	apiVersion: "v1alpha1"
	name:       "oci"
	instances: {
		podinfo: {
			module: {
				url:     "oci://ghrc.io/nalum/timoni/modules/oci"
				version: "0.1.0"
			}
			namespace: "flux-system"
			values: {
				clusterName:     _clusterName
				environmentName: _environmentName
				regionName:      _regionName
				artifacts: [
					{
						name:     "pod-info-root"
						artifact: "nalum/oci/pod-info-root"
						registry: "ghcr.io"

						source: interval: "20m0s"

						kustomize: path:     "./kustomize"
						kustomize: interval: "5m0s"

						enabledClusters: ["wge.dev.us-west-2.test-1"]
					},
					{
						name:     "pod-info-paths"
						artifact: "nalum/oci/pod-info-paths"
						registry: "ghcr.io"

						enabledEnvironments: ["dev"]
						enabledRegions: ["us-east-1"]

						promotion: type: "custom"
						promotion: versioning: [
							{
								tag: "staging"
								clusters: ["wge.dev.us-east-1.test-2"]
							},
						]
					},
				]
			}
		}
	}
}
