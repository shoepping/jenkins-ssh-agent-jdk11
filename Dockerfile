# docker build -t shoepping/jenkins-ssh-agent-jdk11:20.05.22 ./
# docker login -u shoepping
# docker push shoepping/jenkins-ssh-agent-jdk11:20.05.22
# https://hub.docker.com/r/jenkins/ssh-agent/tags
FROM jenkins/ssh-agent:3.0.0-jdk11

# https://github.com/docker/docker-ce/releases
ENV DOCKER_VERSION=23.0.1
ENV DEBIAN_DOCKER_VERSION=5:${DOCKER_VERSION}~3-0~debian-buster

# https://github.com/docker/compose/releases
ENV DOCKER_COMPOSE_VERSION=1.28.2

LABEL DOCKER_COMPOSE_VERSION=${DOCKER_COMPOSE_VERSION} \
      DOCKER_VERSION=${DOCKER_VERSION}

RUN apt-get update
RUN apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     dnsutils \
     gnupg2 \
     jq \
     netcat \
     software-properties-common

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN add-apt-repository \
    "deb [arch=amd64] https://apt.releases.hashicorp.com \
    $(lsb_release -cs) \
    main"

RUN apt-get update
RUN apt-get install -y terraform

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
