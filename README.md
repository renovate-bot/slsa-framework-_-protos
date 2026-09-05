# protos

Protocol buffer definitions for the SLSA attestation predicates.

## Layout

Each predicate lives at `proto/<track>/<version>/predicate.proto`. The Go
packages are generated at the repo root, so the import paths are
`github.com/slsa-framework/protos/<track>/<version>`:

| Predicate | Type URI | Proto | Go import path |
| --- | --- | --- | --- |
| Build provenance v1 | `https://slsa.dev/provenance/v1` | [`proto/build/v1/predicate.proto`](proto/build/v1/predicate.proto) | `github.com/slsa-framework/protos/build/v1` |
| Build provenance v0.2 | `https://slsa.dev/provenance/v0.2` | [`proto/build/v02/predicate.proto`](proto/build/v02/predicate.proto) | `github.com/slsa-framework/protos/build/v02` |
| Verification summary (VSA) v1 | `https://slsa.dev/verification_summary/v1` | [`proto/vsa/v1/predicate.proto`](proto/vsa/v1/predicate.proto) | `github.com/slsa-framework/protos/vsa/v1` |
| Source provenance v1 | source track (source-tool) | [`proto/sourcetool/v1/predicate.proto`](proto/sourcetool/v1/predicate.proto) | `github.com/slsa-framework/protos/sourcetool/v1` |

The build and VSA predicates were migrated from
[in-toto/attestation](https://github.com/in-toto/attestation) via slsa-core,
and the source predicate from
[slsa-framework/source-tool](https://github.com/slsa-framework/source-tool).
Message and field definitions are unchanged, so the wire and JSON forms remain
compatible.

The predicates reference in-toto elements where the spec does (e.g.
`ResourceDescriptor`). Nothing is vendored: `make proto-deps` fetches the
upstream in-toto protos out of the `go.mod`-pinned
[in-toto/attestation](https://github.com/in-toto/attestation) Go module into
the gitignored `third_party/` directory, where `buf` resolves the imports.
The in-toto protos are never generated here — the generated Go uses the
upstream types from `github.com/in-toto/attestation/go/v1`, so the proto
sources and the Go types always come from the same upstream version.

## Working with the protos

```sh
make tools     # install the pinned protoc-gen-go
make lint      # buf lint (fetches the in-toto protos first)
make generate  # regenerate the Go packages (fetches the in-toto protos first)
make tidy      # sync go.mod/go.sum
```
