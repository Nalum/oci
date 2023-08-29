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
nalum/oci/pod-info-paths: Cloning git@github.com:stefanprodan/podinfo.git to /tmp/oci-cue/nalum/oci/pod-info-paths
nalum/oci/pod-info-root: Cloning git@github.com:stefanprodan/podinfo.git to /tmp/oci-cue/nalum/oci/pod-info-root
nalum/oci/base: Cloning git@github.com:nalum/oci.git to /tmp/oci-cue/nalum/oci/base
nalum/oci/base: Getting Revision
nalum/oci/base: Getting Short SHA
nalum/oci/base: Testing Artifact for changes and pushing if needed
nalum/oci/pod-info-root: Getting Revision
nalum/oci/pod-info-root: Getting Short SHA
nalum/oci/pod-info-root: Testing Artifact for changes and pushing if needed
✗ GET https://ghcr.io/v2/nalum/oci/base/manifests/main: MANIFEST_UNKNOWN: manifest unknown
► pushing artifact to ghcr.io/nalum/oci/base:33ed962
✗ GET https://ghcr.io/v2/nalum/oci/pod-info-root/manifests/master: MANIFEST_UNKNOWN: manifest unknown
► pushing artifact to ghcr.io/nalum/oci/pod-info-root:4892983
nalum/oci/pod-info-paths: Getting Revision
nalum/oci/pod-info-paths: Getting Short SHA
nalum/oci/pod-info-paths: Testing Artifact for changes and pushing if needed
✔ artifact successfully pushed to ghcr.io/nalum/oci/base@sha256:79de95f176bcb0207a30c7f1d4a454da5b4e3af1ce715403ba662f76722e2049
► tagging artifact
✗ GET https://ghcr.io/v2/nalum/oci/pod-info-paths/manifests/v5.x: MANIFEST_UNKNOWN: manifest unknown
► pushing artifact to ghcr.io/nalum/oci/pod-info-paths:6596ed0
✔ artifact successfully pushed to ghcr.io/nalum/oci/pod-info-root@sha256:df885b95f39c3b4c1a65399165cac23bbcb52de0586a1ca88d29f3c898f4613a
► tagging artifact
✔ artifact tagged as ghcr.io/nalum/oci/base:main
✔ artifact successfully pushed to ghcr.io/nalum/oci/pod-info-paths@sha256:6f30b5792c7845e70ffb93a0f6f5a15980fbd016acc9704c3b4c5d8368fb7d17
► tagging artifact
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-root:master
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-paths:v5.x
```

If run again before any new changes are introduce we will not create any new artifacts though tags will be reapplied:

```bash
❯ cue cmd push
nalum/oci/pod-info-paths: Cloning git@github.com:stefanprodan/podinfo.git to /tmp/oci-cue/nalum/oci/pod-info-paths
nalum/oci/base: Cloning git@github.com:nalum/oci.git to /tmp/oci-cue/nalum/oci/base
nalum/oci/pod-info-root: Cloning git@github.com:stefanprodan/podinfo.git to /tmp/oci-cue/nalum/oci/pod-info-root
nalum/oci/base: Getting Revision
nalum/oci/base: Getting Short SHA
nalum/oci/base: Testing Artifact for changes and pushing if needed
✔ no changes detected
nalum/oci/pod-info-paths: Getting Revision
nalum/oci/pod-info-paths: Getting Short SHA
nalum/oci/pod-info-paths: Testing Artifact for changes and pushing if needed
✔ no changes detected
nalum/oci/pod-info-root: Getting Revision
nalum/oci/pod-info-root: Getting Short SHA
nalum/oci/pod-info-root: Testing Artifact for changes and pushing if needed
✔ no changes detected
```

Finally if a change is introduced then a new artifact will be created and tagged:

```bash
❯ cue cmd push
nalum/oci/pod-info-paths: Cloning git@github.com:stefanprodan/podinfo.git to /tmp/oci-cue/nalum/oci/pod-info-paths
nalum/oci/base: Cloning git@github.com:nalum/oci.git to /tmp/oci-cue/nalum/oci/base
nalum/oci/pod-info-root: Cloning git@github.com:stefanprodan/podinfo.git to /tmp/oci-cue/nalum/oci/pod-info-root
nalum/oci/base: Getting Revision
nalum/oci/base: Getting Short SHA
nalum/oci/base: Testing Artifact for changes and pushing if needed
✗ the remote artifact contents differs from the local one
► pushing artifact to ghcr.io/nalum/oci/base:dfaa244
nalum/oci/pod-info-paths: Getting Revision
nalum/oci/pod-info-paths: Getting Short SHA
nalum/oci/pod-info-paths: Testing Artifact for changes and pushing if needed
✔ artifact successfully pushed to ghcr.io/nalum/oci/base@sha256:a7c2c20547ec40e0c73e4bee85d4c5b2ca31336b21a10c17ba08412a05c8c6b1
► tagging artifact
nalum/oci/pod-info-root: Getting Revision
nalum/oci/pod-info-root: Getting Short SHA
nalum/oci/pod-info-root: Testing Artifact for changes and pushing if needed
✔ no changes detected
✔ no changes detected
✔ artifact tagged as ghcr.io/nalum/oci/base:main
```

Additional Tags can be added to these artifacts by running the `tag` command:

```bash
❯ cue cmd -t additionalTag=prod -t versionTag=0.1.3 tag
nalum/oci/pod-info-paths: Tagging Artifact with Additional Tag prod
nalum/oci/pod-info-root: Tagging Artifact with Version 0.1.3
nalum/oci/base: Tagging Artifact with Additional Tag prod
nalum/oci/base: Tagging Artifact with Version 0.1.3
nalum/oci/pod-info-paths: Tagging Artifact with Version 0.1.3
nalum/oci/pod-info-root: Tagging Artifact with Additional Tag prod
► tagging artifact
► tagging artifact
► tagging artifact
► tagging artifact
► tagging artifact
► tagging artifact
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-root:prod
✔ artifact tagged as ghcr.io/nalum/oci/base:0.1.3
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-paths:0.1.3
✔ artifact tagged as ghcr.io/nalum/oci/base:prod
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-paths:prod
✔ artifact tagged as ghcr.io/nalum/oci/pod-info-root:0.1.3
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
