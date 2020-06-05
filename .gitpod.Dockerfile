FROM gitpod/workspace-full:latest

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/

USER root
RUN apt-get update && apt-get install -y \
        openjdk-8-jdk \
        openssh-server \
        sudo \
        tmux \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*;

USER gitpod

RUN mkdir -p ~/bin;
ENV PATH="$HOME/bin:$PATH";
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo;
RUN chmod a+x ~/bin/repo;
ENV USE_CCACHE=1
ENV CCACHE_EXEC=/usr/bin/ccache
ENV CCACHE_COMPRESS=1
ENV  ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G"
# Give back control
USER root
