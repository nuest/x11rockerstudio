FROM rocker/r-base

# Install RStudio
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libssl1.0.2 \
    libgstreamer1.0-0 \
    libgstreamer-plugins-base1.0-0 \
    libglu1 \
    libxcomposite-dev \ 
    libxslt1-dev \
    libxcb1 \
    libx11-xcb1 \
    libx11-xcb-dev \ 
    qt5-default \
    # needed for r-base
    libedit2

WORKDIR /tmp
RUN wget -q https://download1.rstudio.org/rstudio-xenial-1.0.153-amd64.deb \
    && dpkg -i rstudio-xenial-1.0.153-amd64.deb

RUN mkdir -p /etc/sudoers.d

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
CMD /usr/lib/rstudio/bin/rstudio
