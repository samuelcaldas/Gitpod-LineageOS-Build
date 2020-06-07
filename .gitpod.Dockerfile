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
RUN chpasswd root
RUN service ssh start
RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN mkdir -p ~/.config/code-server
RUN echo 'bind-addr: 0.0.0.0:443 \n auth: password \n password: hebroN01 \n cert: true \n' >> ~/.config/code-server/config.yaml 


USER gitpod

RUN mkdir -p ~/bin
ENV PATH="$HOME/bin:$PATH"
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo;
RUN chmod a+x ~/bin/repo;

ENV USE_CCACHE=1
ENV CCACHE_EXEC=/usr/bin/ccache
# ENV CCACHE_COMPRESS=1
# ENV  ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G"

# Give back control
USER root
