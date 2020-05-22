# docker build -t shoepping/jenkins-ssh-agent-jdk8:20.05.22 ./
# docker login -u shoepping
# docker push shoepping/jenkins-ssh-agent-jdk8:20.05.22
FROM jenkins/ssh-agent:2.0.1-jdk11

ENV DOCKER_VERSION=19.03.9
ENV DOCKER_COMPOSE_VERSION=1.25.5
ENV DEBIAN_DOCKER_VERSION=5:${DOCKER_VERSION}~3-0~debian-buster

LABEL DOCKER_COMPOSE_VERSION=${DOCKER_COMPOSE_VERSION} \
      DOCKER_VERSION=${DOCKER_VERSION}

RUN apt-get update
RUN apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     jq \
     software-properties-common

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable"

RUN apt-get update
RUN apt-cache madison docker-ce

RUN apt-get install -y \
        docker-ce=${DEBIAN_DOCKER_VERSION} \
        docker-ce-cli=${DEBIAN_DOCKER_VERSION} \
        containerd.io

RUN usermod -aG docker jenkins

RUN curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

RUN chmod +x /usr/local/bin/docker-compose
RUN docker-compose --version
