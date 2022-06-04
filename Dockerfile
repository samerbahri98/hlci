FROM ubuntu:20.04

RUN apt-get update \
    && apt-get install --no-install-recommends -y software-properties-common=0.98.9.2 locale=2.31 \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/Budapest

RUN apt-get update -y && apt-get install -y --no-install-recommends ssh=9.0 sudo=1.9.10 openssh-server=9.0 python3-pip=20.1.1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home -s /bin/bash vagrant

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo -n 'vagrant:vagrant' | chpasswd

RUN echo 'vagrant ALL = NOPASSWD: ALL' > /etc/sudoers.d/vagrant \
    && chmod 440 /etc/sudoers.d/vagrant \
    && mkdir -p /home/vagrant/.ssh \
    && chmod 700 /home/vagrant/.ssh

WORKDIR /home/vagrant

COPY hlci_ansible.pub .

RUN cat hlci_ansible.pub > /home/vagrant/.ssh/authorized_keys \
    && rm -rf hlci_ansible \
    && chmod 600 /home/vagrant/.ssh/authorized_keys \
    && chown -R vagrant:vagrant /home/vagrant/.ssh \
    && sed -i -e 's/Defaults.*requiretty/#&/' /etc/sudoers \
    && sed -i -e 's/\(UsePAM \)yes/\1 no/' /etc/ssh/sshd_config \
    && mkdir /var/run/sshd \
    && pip install ansible=2.14 ansible-vault=2.9 yq=2.14.0

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]