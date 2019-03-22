# docgen-docker
This project defines a Docker container for generating
[OmegaT](https://omegat.org) docs.

## Requirements
- [Docker](https://www.docker.com/products/docker-desktop)

## Usage
Invoke from the OmegaT `doc_src` dir as so:

```sh
docker run -i --rm -v $(dirname $PWD):/work/root omegatorg/docgen -Dlanguage=en html
```

The arguments after `omegatorg/docgen` are those supplied to `ant` according to
the [docs
readme](https://sourceforge.net/p/omegat/svn/HEAD/tree/trunk/doc_src/Readme.txt).

You may want to create a wrapper script like the following, named
e.g. `docgen`:

```sh
#!/bin/sh

exec docker run -i --rm -v $(dirname $PWD):/work/root omegatorg/docgen "$@"
```

...which you can invoke like so:

```sh
docgen -Dlanguage=en html
```
