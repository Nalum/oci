# oci

This repo provides a cue tool cli to build OCI Artifacts from Git Repos.

## Artifact Definition

To define an artifact you need to add the details to `data.cue` with the following information:

```cue
artifacts: [
    {
        name:           "nalum/oci/base"
        source:         "git@github.com:nalum/oci.git"
        targetRegistry: "ghcr.io"
        targetRef:      "main"
        artifactRoot:   "./"
        includePaths:   ["base"]
        annotations:    [
            {
                name: "author"
                value: "nalum"
            }
        ]
    }
]
```

The above defines the OCI Artifact `ghcr.io/nalum/oci/base`, the tool will clone the source repo and run the appropriate
flux oci commands to create and tag the OCI Artifact.

e.g.

```bash
❯ cue push
fatal: No names found, cannot describe anything.
✗ GET https://ghcr.io/v2/nalum/oci/base/manifests/main: MANIFEST_UNKNOWN: manifest unknown
► pushing artifact to ghcr.io/nalum/oci/base:9ccb5c1
✔ artifact successfully pushed to ghcr.io/nalum/oci/base@sha256:d78ec1a8988a42517a5ec5a951f487e265bc3d0ed91d6e73adfa4c17f4febcb5
► tagging artifact
✗ GET https://ghcr.io/v2/nalum/oci/pod-info-root/manifests/master: MANIFEST_UNKNOWN: manifest unknown
► pushing artifact to ghcr.io/nalum/oci/pod-info-root:4892983
✗ GET https://ghcr.io/v2/nalum/oci/pod-info-paths/manifests/v5.x: MANIFEST_UNKNOWN: manifest unknown
► pushing artifact to ghcr.io/nalum/oci/pod-info-paths:6596ed0
✔ artifact tagged as ghcr.io/nalum/oci/base:main
► tagging artifact
✔ artifact successfully pushed to ghcr.io/nalum/oci/pod-info-root@sha256:9713e8d30ec8a806af133e04d05506ed0f54c8f5b1023d8f8cdfc62ea36c05fd
► tagging artifact
✔ artifact successfully pushed to ghcr.io/nalum/oci/pod-info-paths@sha256:95d4bc3e6e9d38736149bd4afdad09cfa9cb08575def4f192e752f6cee5667e9
► tagging artifact
✔ artifact tagged as ghcr.io/nalum/oci/base:0.1.0
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-root:master
► tagging artifact
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-paths:v5.x
► tagging artifact
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-root:6.4.1
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-paths:5.0.2
```

If run again before any new changes are introduce we will not create any new artifacts though tags will be reapplied:

```bash
❯ cue push
fatal: No names found, cannot describe anything.
✔ no changes detected
► tagging artifact
✔ no changes detected
► tagging artifact
✔ artifact tagged as ghcr.io/nalum/oci/base:main
► tagging artifact
✔ no changes detected
► tagging artifact
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-root:master
► tagging artifact
✔ artifact tagged as ghcr.io/nalum/oci/base:0.1.0
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-paths:v5.x
► tagging artifact
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-root:6.4.1
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-paths:5.0.2
```

Finally if a change is introduced then a new artifact will be created and tagged:

```bash
❯ cue push
fatal: No names found, cannot describe anything.
✗ the remote artifact contents differs from the local one
► pushing artifact to ghcr.io/nalum/oci/base:fdbff8e
✔ artifact successfully pushed to ghcr.io/nalum/oci/base@sha256:53ae7e37abde043c287f8459b5488845e9972a76cb0166e041e821a4a61a8811
► tagging artifact
✔ no changes detected
► tagging artifact
✔ no changes detected
► tagging artifact
✔ artifact tagged as ghcr.io/nalum/oci/base:main
► tagging artifact
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-paths:v5.x
► tagging artifact
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-root:master
► tagging artifact
✔ artifact tagged as ghcr.io/nalum/oci/base:0.1.0
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-paths:5.0.2
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-root:6.4.1
```

## Listing Artifacts

Also provided is `cue ls` which will present the `data.cue` information in a table:

```bash
❯ cue ls
OCI Artifact                       Git Repository                            Target Ref   Artifact Root   Include Paths   Annotations
ghcr.io/nalum/oci/base             git@github.com:nalum/oci.git              main         ./base
ghcr.io/nalum/oci/pod-info-root    git@github.com:stefanprodan/podinfo.git   master       ./kustomize                     org.opencontainers.image.authors=stefanprodan,org.opencontainers.image.source=https://github.com/nalum/oci
ghcr.io/nalum/oci/pod-info-paths   git@github.com:stefanprodan/podinfo.git   v5.x         ./              kustomize       org.opencontainers.image.authors=stefanprodan,org.opencontainers.image.source=https://github.com/nalum/oci
```
