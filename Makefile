CLI_CMD ?= docker
USER ?= omegatorg
 

build: build_alpine build_genpdf

build_alpine:
	${CLI_CMD} build --tag omegatorg/docgen:alpine .

build_genpdf:
	${CLI_CMD} build --tag omegatorg/docgen:pdfgen . --build-arg pdfgen=1

push:
	${CLI_CMD} push omegatorg/docgen:alpine
	${CLI_CMD} push omegatorg/docgen:genpdf

login:
	${CLI_CMD} login -u ${USER} --password-stdin

logout:
	${CLI_CMD} logout

