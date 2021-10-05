FROM rocker/verse

# Install RStudio
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libgstreamer1.0-0 \
    libgstreamer-plugins-base1.0-0 \
    libglu1 \
    libxcomposite-dev \
    libxslt1-dev \
    libxcb1 \
    libxcursor1 \
    libxdamage-dev \
    libx11-xcb1 \
    libxkbcommon-x11-0 \
    libx11-xcb-dev \
    qt5-default

WORKDIR /tmp
RUN wget -q https://download1.rstudio.org/desktop/bionic/amd64/rstudio-2021.09.0-351-amd64.deb \
    && dpkg -i rstudio-2021.09.0-351-amd64.deb

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
ENV QT_QPA_PLATFORM=xcb
ENV QT_QPA_PLATFORM_PLUGIN_PATH=/usr/lib/rstudio/plugins/platforms/
CMD /usr/lib/rstudio/bin/rstudio
