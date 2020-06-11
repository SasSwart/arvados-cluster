FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y wget gnupg python-lxml openssh-client
RUN wget -O - https://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -
RUN echo "deb http://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest bionic main" > /etc/apt/sources.list.d/saltstack.list
RUN apt-get update

RUN apt-get install -y salt-cloud

CMD salt-cloud -p basic -m /root/map -P
