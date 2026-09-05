# SPDX-FileCopyrightText: Copyright 2026 The SLSA Authors
# SPDX-License-Identifier: Apache-2.0

# Pinned version of the Go protobuf plugin used for code generation.
PROTOC_GEN_GO_VERSION ?= v1.36.12

# Install the code generation plugins onto the PATH (GOBIN).
.PHONY: tools
tools:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@$(PROTOC_GEN_GO_VERSION)

# Fetch the upstream in-toto protos out of the go.mod-pinned Go module so buf
# can resolve the in_toto_attestation imports. Nothing is vendored: the protos
# come from the exact module version go.mod pins, keeping the Go types and the
# proto sources in lockstep.
.PHONY: proto-deps
proto-deps:
	go mod download github.com/in-toto/attestation
	rm -rf third_party/proto
	mkdir -p third_party/proto/in_toto_attestation/v1
	cp $$(go list -m -f '{{.Dir}}' github.com/in-toto/attestation)/protos/in_toto_attestation/v1/*.proto third_party/proto/in_toto_attestation/v1/
	chmod -R u+w third_party/proto

# Generate the Go packages from the protos.
.PHONY: generate
generate: proto-deps
	buf generate

# Verify the protos lint cleanly.
.PHONY: lint
lint: proto-deps
	buf lint

# Sync go.mod/go.sum after (re)generating.
.PHONY: tidy
tidy:
	go mod tidy
