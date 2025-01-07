# docgen-docker

This project defines an OCI standard container for generating [OmegaT](https://omegat.org) documents.

## Requirements to run

To generate container images, you need to prepare container runtime, and OCI standard CLI.
It supports aarch64/ARM64 and x86_64/AMD64 platform architectures.

You have several options;

### integrated desktop application: Docker Desktop or Rancher Desktop

- [Docker](https://www.docker.com/products/docker-desktop)
- [Rancher Desktop](https://rancherdesktop.io/)

### Linux native OCI runtime and CLI tool

- [Containerd](https://containerd.io/)
- [nerdctl](https://github.com/containerd/nerdctl)

## Usage

Invoke from the OmegaT `doc_src` dir as so:

```shell
docker run -i --rm -v $(dirname $PWD):/work/root omegatorg/docgen -Dlanguage=en html
```

The arguments after `omegatorg/docgen` are those supplied to `ant` according
to the developer manual's section [Manual build using container](https://omegat.readthedocs.io/en/latest/07.ManualBuildUsingContainer/)
and [building the documentation manually](https://omegat.readthedocs.io/en/latest/08.ManuallyBuildDocumentation/).

You may want to create a wrapper script like the following, named
e.g. `docgen`:

```shell
#!/bin/sh

exec docker run -i --rm -v $(dirname $PWD):/work/root omegatorg/docgen "$@"
```

...which you can invoke like so:

```shell
docgen -Dlanguage=en html
```

## Build

To support multiple platform architecture like Aarch64/ARM64 and Amd64 such as M1 mac and Windows 11 for ARM,
it should be built as [multi-platform container image](https://docs.docker.com/build/building/multi-platform/).

### Prerequisites:

- Git LFS to checkout jar files under lib/
- Containerd or Docker Engine with QEMU installed
- The container image store enabled

### Build with nerdctl

```shell
echo PassWord | env CLI_CMD=nerdctl USER=myname make login
env CLI_CMD=nerdctl make build
```
