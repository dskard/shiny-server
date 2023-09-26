DOCKER_DIR=docker/jenkins
WORKDIR=/opt/work
DOCKER_IMAGE_UBUNTU=rstudio/shiny-server:ubuntu-18.04-x86_64
DOCKER_IMAGE_UBUNTU_20=rstudio/shiny-server:ubuntu-20.04-x86_64
DOCKER_IMAGE_CENTOS=rstudio/shiny-server:centos7-x86_64
DOCKER_IMAGE_ROCKY_8=rstudio/shiny-server:rocky8-x86_64

.PHONY: build
build: build-centos build-ubuntu build-rocky-8 build-ubuntu-20.04


.PHONY: build-centos
build-centos:
	docker build \
	    --build-arg JENKINS_UID=`id -u` \
	    --build-arg JENKINS_GID=`id -g` \
	    -t ${DOCKER_IMAGE_CENTOS} \
	    -f ${DOCKER_DIR}/Dockerfile.centos7 \
	    .

.PHONY: build-rocky-8
build-rocky-8:
	docker build \
	    --build-arg JENKINS_UID=`id -u` \
	    --build-arg JENKINS_GID=`id -g` \
	    -t ${DOCKER_IMAGE_ROCKY_8} \
	    -f ${DOCKER_DIR}/Dockerfile.rocky8 \
	    .

.PHONY: build-ubuntu
build-ubuntu:
	docker build \
	    --build-arg JENKINS_UID=`id -u` \
	    --build-arg JENKINS_GID=`id -g` \
	    -t ${DOCKER_IMAGE_UBUNTU} \
	    -f ${DOCKER_DIR}/Dockerfile.ubuntu-18.04 \
	    .

.PHONY: build-ubuntu-20.04
build-ubuntu-20.04:
	docker build \
	    --build-arg JENKINS_UID=`id -u` \
	    --build-arg JENKINS_GID=`id -g` \
	    -t ${DOCKER_IMAGE_UBUNTU_20} \
	    -f ${DOCKER_DIR}/Dockerfile.ubuntu-20.04 \
	    .

.PHONY: packages
packages: packages-centos packages-ubuntu

.PHONY: packages-centos
packages-centos:
	docker run -it --rm --init \
	    --user=`id -u`:`id -g` \
	    --volume=${CURDIR}:${WORKDIR} \
	    --workdir=${WORKDIR} \
	    --env OS=centos7 \
	    --env ARCH=x86_64 \
	    ${DOCKER_IMAGE_CENTOS} ./packaging/make-package-jenkins.sh

.PHONY: packages-rocky-8
packages-rocky-8:
	docker run -it --rm --init \
	    --user=`id -u`:`id -g` \
	    --volume=${CURDIR}:${WORKDIR} \
	    --workdir=${WORKDIR} \
	    --env OS=rocky8 \
	    --env ARCH=x86_64 \
	    ${DOCKER_IMAGE_ROCKY_8} ./packaging/make-package-jenkins.sh

.PHONY: packages-ubuntu
packages-ubuntu:
	docker run -it --rm --init \
	    --user=`id -u`:`id -g` \
	    --volume=${CURDIR}:${WORKDIR} \
	    --workdir=${WORKDIR} \
	    --env OS=ubuntu-18.04 \
	    --env ARCH=x86_64 \
	    ${DOCKER_IMAGE_UBUNTU} ./packaging/make-package-jenkins.sh

.PHONY: packages-ubuntu-20
packages-ubuntu-20:
	docker run -it --rm --init \
	    --user=`id -u`:`id -g` \
	    --volume=${CURDIR}:${WORKDIR} \
	    --workdir=${WORKDIR} \
	    --env OS=ubuntu-20.04 \
	    --env ARCH=x86_64 \
	    ${DOCKER_IMAGE_UBUNTU_20} ./packaging/make-package-jenkins.sh

.PHONY: dist-clean
dist-clean:
	rm -rf \
		bin/shiny-server \
		build/ \
		ext/ \
		node_modules/ \
		packaging/build/ \
		src/launcher.h
