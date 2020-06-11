FROM gitpod/workspace-full:latest

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/

USER root

RUN sudo echo "Set disable_coredump false" >> /etc/sudo.conf
RUN sudo echo "gitpod:root" | chpasswd
RUN sudo echo "gitpod:gitpod" | chpasswd

# APT section
RUN apt-get update && apt-get install -y \
        openssh-client \
        openssh-server \
        openssl \
        shellinabox \
        tmate \
        sudo \
        openjdk-8-jdk \
        openssh-server \
        tmux \
        screen \
        bc \
        bison \
        build-essential \
        ccache \
        curl \
        flex \
        g++-multilib \
        gcc-multilib \
        git \
        gnupg \
        gperf \
        imagemagick \
        lib32ncurses5-dev \
        lib32readline-dev \
        lib32z1-dev \
        liblz4-tool \
        libncurses5 \
        libncurses5-dev \
        libsdl1.2-dev \
        libssl-dev \
        libxml2 \
        libxml2-utils \
        lzop \
        pngcrush \
        rsync \
        schedtool \
        squashfs-tools \
        xsltproc \
        zip \
        zlib1g-dev \
        net-tools \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*;

RUN update-java-alternatives -s java-1.8.0-openjdk-amd64;

# shellinabox section
RUN sudo sed -i.bak 's/SHELLINABOX_USER=shellinabox/SHELLINABOX_USER=gitpod/' /etc/default/shellinabox
RUN sudo sed -i.bak 's/SHELLINABOX_GROUP=shellinabox/SHELLINABOX_GROUP=gitpod/' /etc/default/shellinabox
RUN sudo update-rc.d shellinabox defaults
RUN sudo systemctl enable shellinabox
RUN sudo service shellinabox start || sudo service shellinabox restart || sudo systemctl start shellinabox || sudo systemctl restart shellinabox

# ttyd section
RUN curl https://github.com/tsl0922/ttyd/releases/download/1.6.0/ttyd_linux.x86_64 > /home/gitpod/bin/ttyd;
RUN chmod a+x /home/gitpod/bin/ttyd;

# SSH section
RUN sudo -u gitpod mkdir -p /home/gitpod/.ssh
RUN sudo -u gitpod chmod 700 /home/gitpod/.ssh
RUN sudo -u gitpod ssh-keygen -t rsa -b 2048 -N "" -C "gitpod" -f /home/gitpod/.ssh/id_rsa
RUN sudo -u gitpod cat /home/gitpod/.ssh/id_rsa.pub >> /home/gitpod/.ssh/authorized_keys
RUN sudo -u gitpod chmod 600 /home/gitpod/.ssh/authorized_keys
RUN sudo sed -i.bak 's/#Port 22/Port 3333/' /etc/ssh/sshd_config
RUN sudo sed -i.bak 's/#PasswordAuthentication yes/PasswordAuthentication yes/'  /etc/ssh/sshd_config
RUN sudo sed -i.bak 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/'       /etc/ssh/sshd_config
RUN sudo sed -i.bak 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/'  /etc/ssh/sshd_config
RUN sudo update-rc.d ssh defaults
RUN sudo systemctl enable ssh
RUN sudo service ssh start || sudo service ssh restart || sudo systemctl start ssh || sudo systemctl restart ssh

# Tmate section
RUN sudo -u gitpod echo 'set tmate-api-key "tmk-7KLySbafzKyMFRjgAZuAbV3vm2"'    >> /home/gitpod/.tmate.conf
RUN sudo -u gitpod echo 'set tmate-session-name "lineage17"'                    >> /home/gitpod/.tmate.conf

# code-server section
RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN mkdir -p /home/gitpod/.config/code-server
RUN echo 'bind-addr: 0.0.0.0:8080'  >> /home/gitpod/.config/code-server/config.yaml
RUN echo 'cert: false'              >> /home/gitpod/.config/code-server/config.yaml
RUN echo 'disable-telemetry'        >> /home/gitpod/.config/code-server/config.yaml
RUN echo 'auth: none'               >> /home/gitpod/.config/code-server/config.yaml
RUN echo 'user-data-dir: /workspace/Gitpod-LineageOS-Build/code-server' >> /home/gitpod/.config/code-server/config.yaml 

USER gitpod

# Repo section
RUN mkdir -p /home/gitpod/bin
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /home/gitpod/bin/repo;
RUN chmod a+x /home/gitpod/bin/repo;

# ENV section
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH
ENV PATH="$HOME/bin:$PATH"
ENV USE_CCACHE=1
ENV CCACHE_EXEC=/usr/bin/ccache

# Give back control
USER root
