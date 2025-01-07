CLI_CMD ?= docker
USER ?= omegatorg
 

build: build_alpine build_genpdf

build_alpine:
	${CLI_CMD} build --tag omegatorg/docgen:alpine --platform linux/amd64,linux/arm64 .

build_genpdf:
	${CLI_CMD} build --tag omegatorg/docgen:pdfgen --platform linux/amd64,linux/arm64 . --build-arg pdfgen=1

push:
	${CLI_CMD} push --platform linux/amd64,linux/arm64 omegatorg/docgen:alpine
	${CLI_CMD} push --platform linux/amd64,linux/arm64 omegatorg/docgen:genpdf

login:
	${CLI_CMD} login -u ${USER} --password-stdin

logout:
	${CLI_CMD} logout

