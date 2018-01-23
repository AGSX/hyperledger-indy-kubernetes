FROM ubuntu:xenial

###
# Install dependencies
# TODO: Cleanup
###
RUN apt-get update -y && \
    apt-get install -y \ 
	  git \
	  wget \
	  python3.5 \
	  python3-pip \
	  python-setuptools \
	  python3-nacl \
	  apt-transport-https \
	  ca-certificates && \
    pip3 install -U \ 
	  pip \ 
	  setuptools && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68DB5E88 && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BD33704C && \
    echo "deb https://repo.evernym.com/deb xenial master" >> /etc/apt/sources.list && \
    echo "deb https://repo.sovrin.org/deb xenial master" >> /etc/apt/sources.list && \
		echo "deb https://repo.sovrin.org/sdk/deb xenial master" >> /etc/apt/sources.list && \
    apt-get update -y && apt-get install -y indy-node indy-cli && \
		rm -rf /var/lib/apt/lists/* && \
		rm -rf /home/indy/.indy/*

###
# Add startup script
###
ENV node node-name
ENV node_port 9701
ENV client_port 9702

ADD start /home/indy/start
ADD new_indy_node.sh /home/indy/new_indy_node.sh
ADD new_indy_key.sh /home/indy/new_indy_key.sh
RUN chmod +x /home/indy/*

###
# Need to have these volumes for image to work
###
VOLUME /run
VOLUME /run/lock
VOLUME /var/lib/indy

###
# set user to INDY
###
# USER indy
WORKDIR /home/indy

ENTRYPOINT ["/home/indy/start"]
