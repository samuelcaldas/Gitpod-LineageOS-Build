FROM gitpod/workspace-full:latest

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/

USER root
RUN apt-get update && apt-get install -y \
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
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*;
    RUN update-java-alternatives -s java-1.8.0-openjdk-amd64;
    RUN chpasswd gitpod
    RUN adduser gitpod sudo
    RUN service ssh start
    RUN systemctl enable ssh
    RUN curl -fsSL https://code-server.dev/install.sh | sh
    RUN mkdir -p ~/.config/code-server
    RUN chmod 777 ~/.config/code-server
    RUN echo 'bind-addr: 0.0.0.0:443 \n auth: password \n password: hebroN01 \n cert: true \n' >> ~/.config/code-server/config.yaml
    RUN echo url="https://www.duckdns.org/update?domains=gitpod&token=b4d96824-e96c-459a-91e4-de226a8d6ff7&ip=" | curl -k -o ~/duck.log -K -


USER gitpod
RUN mkdir -p ~/.config/code-server
RUN chmod 777 ~/.config/code-server
RUN echo 'bind-addr: 0.0.0.0:443 \n auth: password \n password: hebroN01 \n cert: true \n' >> ~/.config/code-server/config.yaml
RUN code-server
RUN echo 'echo url="https://www.duckdns.org/update?domains=gitpod&token=b4d96824-e96c-459a-91e4-de226a8d6ff7&ip=" | curl -k -o ~/duck.log -K -' >> ~/duck.sh
RUN chmod +x ~/duck.sh
RUN ~/duck.sh
RUN mkdir -p ~/bin
ENV PATH="$HOME/bin:$PATH"
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo;
RUN chmod a+x ~/bin/repo;
ENV USE_CCACHE=1
ENV CCACHE_EXEC=/usr/bin/ccache
# ENV CCACHE_COMPRESS=1
# ENV  ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G"
# RUN mkdir -p /workspace/Gitpod-LineageOS-Build/lineage
RUN cd /workspace/Gitpod-LineageOS-Build/lineage
RUN repo init -u https://github.com/LineageOS/android.git -b lineage-17.1 --depth=1 --groups=all,-notdefault,-device,-darwin,-x86,-x86_x64,-mips,-android-emulator

# Give back control
USER root
