FROM jenkinsci/jnlp-slave

USER root

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y docker.io supervisor

RUN mkdir -p /var/log/docker
RUN mkdir -p /var/log/jenkins-slave

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ENTRYPOINT echo "$0 $*" > /tmp/args && cat /tmp/args && /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
