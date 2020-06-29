# docker build -t shoepping/jenkins-ssh-agent-jdk11:20.05.22 ./
# docker login -u shoepping
# docker push shoepping/jenkins-ssh-agent-jdk11:20.05.22
# https://hub.docker.com/r/jenkins/ssh-agent/tags
FROM jenkins/ssh-agent:2.0.1-jdk11


# https://github.com/Azure/azure-cli/releases
ENV AZURE_CLI_VERSION=2.8.0
ENV DEBIAN_AZURE_CLI_VERSION=${AZURE_CLI_VERSION}-1~buster

# https://github.com/docker/compose/releases
ENV DOCKER_COMPOSE_VERSION=1.26.0

# https://github.com/docker/docker-ce/releases
ENV DOCKER_VERSION=19.03.12
ENV DEBIAN_DOCKER_VERSION=5:${DOCKER_VERSION}~3-0~debian-buster

LABEL AZURE_CLI_VERSION=${AZURE_CLI_VERSION} \
      DOCKER_COMPOSE_VERSION=${DOCKER_COMPOSE_VERSION} \
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

RUN apt-get update
RUN apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg

RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
        tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null

RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
        tee /etc/apt/sources.list.d/azure-cli.list

RUN apt-get update
RUN apt-cache madison azure-cli

RUN apt-get install azure-cli=${DEBIAN_AZURE_CLI_VERSION}
