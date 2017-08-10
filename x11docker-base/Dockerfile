FROM x11docker/lxde

RUN sed -i "s/deb.debian.org/cdn-fastly.deb.debian.org/" /etc/apt/sources.list \
  && sed -i "s/security.debian.org/cdn-fastly.debian.org\/debian-security/" /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    libssl1.0.2 \
    libgstreamer1.0-0 \
    libgstreamer-plugins-base1.0-0 \
    gnupg2 \
    dirmngr \
    libxslt1-dev

RUN apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' \
  && apt-get install -y \
    r-base \
    r-base-dev

WORKDIR /tmp

RUN wget -q https://download1.rstudio.org/rstudio-xenial-1.0.153-amd64.deb \
  && dpkg -i rstudio-xenial-1.0.153-amd64.deb
