FROM ubuntu:focal


ENV VERSION=0.11.1 \
    SERVICE=fail2ban \
    FAIL2BAN_VERSION=0.11.1

# Root password
ENV STIMIO_PASSWORD NONE

# Expose the regular ssh port
EXPOSE 22
# Expose other ports for reverse
EXPOSE 19989:19999


MAINTAINER Mikael PANN <mikael.pann@stimio.fr>


RUN apt-get update && \
    apt-get install -y software-properties-common language-pack-en && \
    apt-get update && \
    apt-get -y --no-install-recommends install bash openssh-server autossh pwgen sshpass systemd rsyslog  supervisor && \
    apt-get -y --no-install-recommends install ca-certificates python3 python3-setuptools python3-pycurl vim \
    wget ipset iptables ssmtp redis-tools curl whois && \
    
    apt-get clean && \
    rm -rf /var/lib/apt/lists && \
    mkdir -p /var/run/sshd && \
    mkdir -p /root/.ssh && \
    sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && \
    sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && \
    sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
    echo "GatewayPorts yes" >> /etc/ssh/sshd_config && \
    rm -rf /var/lib/apt/lists/* &&\

    rm -rf /etc/fail2ban/jail.d && \
    mkdir -p /var/run/fail2ban && \
    cd /tmp && \
    wget https://github.com/fail2ban/fail2ban/archive/${FAIL2BAN_VERSION}.tar.gz -O fail2ban-${FAIL2BAN_VERSION}.tar.gz && \
    tar xvzf fail2ban-${FAIL2BAN_VERSION}.tar.gz && \
    cd fail2ban-${FAIL2BAN_VERSION} && \
    python3 setup.py install && \
    cd / && \
    mkdir -p /usr/local/etc/fail2ban && \
    cp -rp /etc/fail2ban /usr/local/etc && \
    rm -rfv /tmp/*



# Create stimio user
#RUN addgroup -S stimio && adduser -S -G stimio stimio -s /bin/sh

SHELL ["/bin/bash", "-c"]
ARG user=stimio
ARG pwd=stimio
ARG group=stimio
ARG home=/home/$user


RUN useradd --create-home -s /bin/bash $user \
        && echo $user:$pwd | chpasswd \
        && adduser $user sudo



RUN sed -i "s;\GatewayPorts no;GatewayPorts yes;g" /etc/ssh/sshd_config && \
    sed -i "s;\AllowTcpForwarding no;AllowTcpForwarding yes;g" /etc/ssh/sshd_config && \
    sed -i "s;\#PermitRootLogin .*;PermitRootLogin no;g" /etc/ssh/sshd_config

# Generate keys
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
    ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa && \
    mkdir -p /var/run/sshd


    
ADD ssh/run.sh /rune.sh
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD fail2ban/jail.local /etc/fail2ban/jail.local

RUN chmod +x /etc/fail2ban/jail.local
RUN touch /var/log/auth.log
RUN chown syslog:syslog /var/log/auth.log
RUN chmod +x /*.sh

ENV AUTHORIZED_KEYS **None**
ENV ROOT_PASS **None**
ENV PUBLIC_HOST_ADDR **None**
ENV PUBLIC_HOST_PORT **None**
ENV PROXY_PORT **None**

EXPOSE 22
#EXPOSE 1080

ENTRYPOINT ["/usr/bin/supervisord"]



