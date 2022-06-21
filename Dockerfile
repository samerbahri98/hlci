FROM ubuntu:20.04

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    software-properties-common=0.99.9.8 \
    locales=2.31-0ubuntu9.9 \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/Budapest

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    ssh=1:8.2p1-4ubuntu0.5 \
    sudo=1.8.31-1ubuntu1.2 \
    openssh-server=1:8.2p1-4ubuntu0.5 \
    python3-pip=20.0.2-5ubuntu1.6 \
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
    && pip install --no-cache-dir ansible==5.8.0 ansible-vault==2.1.0 yq==2.12.0

EXPOSE 22

EXPOSE 4440

CMD ["/usr/sbin/sshd", "-D"]