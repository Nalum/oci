package main

import (
	"text/tabwriter"
	"tool/cli"
	"tool/exec"
	"strings"
)

clean_tmp: exec.Run & {
	cmd: "rm -rf /tmp/oci-cue"
}

command: ls: {
	task: print: cli.Print & {
		text: tabwriter.Write([
			"OCI Artifact  \tGit Repository  \tTarget Branch  \tArtifact Root  \tInclude Paths  \tAnnotations",
			for x in artifacts {
				"\(x.targetRegistry)/\(x.name)  \t\(x.source)  \t\(x.targetBranch)  \t\(x.artifactRoot)  \t\(strings.Join(x.includePaths, ","))  \t\(strings.Join([ for y in x.annotations {"\(y.name)=\(y.value)"}], ","))"
			},
		])
	}
}

command: push: {
	clean: clean_tmp
	for x in artifacts {
		(x.name): {
			clone: exec.Run & {
				$dep:   command.push.clean.$done
				cmd:    "git clone --quiet --branch \(x.targetBranch) \(x.source) /tmp/oci-cue/\(x.name)"
				stdout: string
			}
			revision: exec.Run & {
				$dep:   clone.$done
				dir:    "/tmp/oci-cue/\(x.name)/.git"
				cmd:    "git rev-parse HEAD"
				stdout: string
				Out:    strings.Trim(stdout, "\n")
			}
			short: exec.Run & {
				$dep:   revision.$done
				dir:    "/tmp/oci-cue/\(x.name)/.git"
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
			print: cli.Print & {
				$dep: short.$done
				//dir: "/tmp/oci-cue/\(x.name)/.git"
				text: "flux push artifact oci://\(x.targetRegistry)/\(x.name):\(short.Out) --path=\"/tmp/oci-cue/\(x.name)/\(x.artifactRoot)\"\(includeSpecific.flag) --source=\"\(x.source)\" --revision=\"\(revision.Out)\" \(strings.Join([ for y in x.annotations {"--annotations=\"\(y.name)=\(y.value)\""}], " "))"
			}
		}
	}
}

command: clean: clean_tmp
