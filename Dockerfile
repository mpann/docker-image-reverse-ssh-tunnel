FROM ubuntu:focal

MAINTAINER Mikael PANN <mikael.pann@stimio.fr>

RUN apt-get update && \
    apt-get -y --no-install-recommends install bash openssh-server autossh pwgen sshpass systemd rsyslog  supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists && \
    mkdir -p /var/run/sshd && \
    mkdir -p /root/.ssh && \
    sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && \
    sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && \
    sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
    echo "GatewayPorts yes" >> /etc/ssh/sshd_config && \
    rm -rf /var/lib/apt/lists/*

ADD run.sh /run.sh
ADD entrypoint.sh /entrypoint.sh
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf


RUN chmod +x /*.sh

ENV AUTHORIZED_KEYS **None**
ENV ROOT_PASS **None**
ENV PUBLIC_HOST_ADDR **None**
ENV PUBLIC_HOST_PORT **None**
ENV PROXY_PORT **None**

EXPOSE 22
EXPOSE 1080

#CMD ["/usr/sbin/rsyslogd", "-n", "&"]

#CMD ["/entrypoint.sh"]

#CMD service rsyslog start 

ENTRYPOINT ["/usr/bin/supervisord"]

#CMD ["/run.sh"]



#ENTRYPOINT ["sh", "/entrypoint.sh"]
#CMD ["/usr/sbin/rsyslogd", "-n", "&"]

