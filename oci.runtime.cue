package main

runtime: {
	apiVersion: "v1alpha1"
	name:       "oci"
	values: [
		{
			query: "k8s:v1:ConfigMap:flux-system:cluster-config"
			for: {
				"CLUSTER_NAME":     "obj.data.clusterName"
				"ENVIRONMENT_NAME": "obj.data.clusterEnvironment"
				"REGION_NAME":      "obj.data.awsRegion"
			}
		},
	]
}
