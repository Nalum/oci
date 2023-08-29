package main

import (
	"text/tabwriter"
	"tool/cli"
	"tool/exec"
	"strings"
)

_pathPrefix: "/tmp/oci-cue/"

additionalTag: string @tag(additionalTag)
versionTag:    string @tag(versionTag)

clean_tmp: exec.Run & {
	cmd: "rm -rf \(_pathPrefix)"
}

command: ls: {
	task: print: cli.Print & {
		text: tabwriter.Write([
			"OCI Artifact  \tGit Repository  \tTarget Ref  \tArtifact Root  \tInclude Paths  \tAnnotations",
			for x in artifacts {
				"\(x.targetRegistry)/\(x.name)  \t\(x.source)  \t\(x.targetRef)  \t\(x.artifactRoot)  \t\(strings.Join(x.includePaths, ","))  \t\(strings.Join([ for y in x.annotations {"\(y.name)=\(y.value)"}], ","))"
			},
		])
	}
}

command: push: {
	clean: clean_tmp
	for x in artifacts {
		(x.name): {
			noteClone: cli.Print & {
				$dep: command.push.clean.$done
				text: "\(x.name): Cloning \(x.source) to \(_pathPrefix)\(x.name)"
			}
			clone: exec.Run & {
				$dep:   noteClone.$done
				cmd:    "git clone --quiet --branch \(x.targetRef) \(x.source) \(_pathPrefix)\(x.name)"
				stdout: string
			}
			noteRevision: cli.Print & {
				$dep: clone.$done
				text: "\(x.name): Getting Revision"
			}
			revision: exec.Run & {
				$dep: noteRevision.$done
				dir:  "\(_pathPrefix)\(x.name)"
				cmd: ["bash", "-c", "echo \"\(x.targetRef)@sha1:$(git rev-parse HEAD)\""]
				stdout: string
				Out:    strings.Trim(stdout, "\n")
			}
			noteShort: cli.Print & {
				$dep: revision.$done
				text: "\(x.name): Getting Short SHA"
			}
			short: exec.Run & {
				$dep:   noteShort.$done
				dir:    "\(_pathPrefix)\(x.name)"
				cmd:    "git rev-parse --short HEAD"
				stdout: string
				Out:    strings.Trim(stdout, "\n")
			}
			includeSpecific: {
				if x.includePaths != [] {
					flag: " --ignore-paths=\"*\(strings.Join([ for y in x.includePaths {",!\(y)"}], ""))\""
				}

				if x.includePaths == [] {
					flag: ""
				}
			}
			notePush: cli.Print & {
				$dep: short.$done
				text: "\(x.name): Testing Artifact for changes and pushing if needed"
			}
			push: exec.Run & {
				$dep: notePush.$done
				dir:  "\(_pathPrefix)\(x.name)"
				cmd: [
					"bash",
					"-c",
					"""
flux diff artifact oci://\(x.targetRegistry)/\(x.name):\(x.targetRef) --path="\(x.artifactRoot)"\(includeSpecific.flag) || \\
( \\
	flux push artifact oci://\(x.targetRegistry)/\(x.name):\(short.Out) --path="\(x.artifactRoot)"\(includeSpecific.flag) --source="\(x.source)" --revision="\(revision.Out)" \(strings.Join([ for y in x.annotations {"--annotations=\"\(y.name)=\(y.value)\""}], " ")) && \\
	flux tag artifact oci://\(x.targetRegistry)/\(x.name):\(short.Out) --tag="\(x.targetRef)" \\
)
""",
				]
			}
		}
	}
}

command: tag: {
	for x in artifacts {
		(x.name): {
			if versionTag != "" {
				noteVersionTag: cli.Print & {
					text: "\(x.name): Tagging Artifact with Version \(versionTag)"
				}
				versionTagTask: exec.Run & {
					$dep: noteVersionTag.$done
					cmd: [
						"bash",
						"-c",
						"""
flux tag artifact oci://\(x.targetRegistry)/\(x.name):\(x.targetRef) --tag="\(versionTag)"
""",
					]
				}
			}
			if additionalTag != "" {
				noteAdditionalTag: cli.Print & {
					text: "\(x.name): Tagging Artifact with Additional Tag \(additionalTag)"
				}
				additionalTagTask: exec.Run & {
					$dep: noteAdditionalTag.$done
					cmd: [
						"bash",
						"-c",
						"""
flux tag artifact oci://\(x.targetRegistry)/\(x.name):\(x.targetRef) --tag="\(additionalTag)"
""",
					]
				}
			}
		}
	}
}

command: clean: clean_tmp
