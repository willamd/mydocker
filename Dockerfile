# @Author: William

FROM   ubuntu:18.04

MAINTAINER William
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y sudo \
    && apt-get install -y zsh \
    && apt-get install -y apt-utils \
    && apt-get install -y wget \
    && apt-get install -y curl
RUN useradd -d /home/william -m william -s /bin/bash  \
    && adduser william sudo \
    && echo "william ALL=(ALL) NOPASSWD : ALL" | tee /etc/sudoers.d/nopasswd4sudo

# application
RUN apt-get install -y redis  \
    && apt-get install -y golang \
    && apt-get install -y python3

# tools
RUN apt-get install -y net-tools \
    && apt-get install -y vim \
    && apt-get install -y git

# ssh
RUN apt-get install -y openssh-server \
    && mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd
RUN sudo sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sudo sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
# Clean apt-cache
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
# zsh    
RUN chsh -s /bin/zsh
RUN usermod -s /bin/zsh william
#zsh
USER william
WORKDIR /home/william
RUN git clone http://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

ENTRYPOINT ["/bin/zsh"]

