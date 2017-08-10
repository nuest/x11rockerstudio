# RStudio Desktop in container

This repository contains some tests to run [RStudio](http://rstudio.com/) Desktop, an IDE for [R](https://r-project.org), in a container.

A first approach is based on [Rocker](https://github.com/rocker-org/rocker) and/or [x11docker](https://github.com/mviereck/x11docker).
Two variants are evaluated here:

- using `x11docker/lxde` base image, installing R + RStudio
- using `rocker/verse`, installing the UI and stuff according to x11docker's Dockerfile, and install RStudio

Both these projects use Debian base images, which helps a lot.

Another approach is sharing the host's X11 socket as shown by [Fábio Rehm](http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/) (originally [for Netbeans](https://github.com/fgrehm/docker-netbeans)).

## Results

### x11docker base image with R

The following commands require x11docker to be install (clone the repo, then run `sudo x11docker --install`). If you prefer not to do that, add the full path to `x11docker` binary in the commands below.

```bash
docker build --tag x11rockerstudio  --file x11docker-base/Dockerfile .

# for testing: docker run --rm -it --entrypoint /bin/bash x11docker/lxde

# start container with LXDE desktop:
x11docker --desktop --sudo --net --clipboard x11rockerstudio

# start container and only start RStudio
x11docker --desktop --sudo --net --clipboard x11rockerstudio /usr/lib/rstudio/bin/rstudio
```

### Rocker base image with x11docker

```bash
docker build --tag rockerstudiox11 --file rocker-base/Dockerfile .

# start container:
x11docker --desktop --sudo --net --clipboard rockerstudiox11
```

The following command is shown by x11docker to be actually executed:

```bash
docker run --user 1000:1000 --group-add video --env USER=daniel -v /home/daniel/.cache/x11docker/X200/passwd:/etc/passd:ro --cap-drop=ALL --security-opt=no-new-privileges --read-only --volume=/tmp --rm --name=x11docker_X200_42a446_rockerstudiox11 --entrypoint= -v /home/daniel/.cache/x11docker/X200/share:/x11docker:ro -e DISPLAY=unix:200 -e XAUTHORITY=/x11docker/Xclientcookie -v /tmp/.X11-unix/X200:/tmp/X200:ro --net=host -- rockerstudiox11 /bin/bash /x11docker/x11docker_CMD
```

This partially shows x11docker works, and how user settings are translated to Docker configuration.

### X11 socket sharing with Rocker base images

This approach works quite well and is most lightweight, because there is no full desktop in the container. But it also has security implications (see also `x11docker`'s README on the topic).

```bash
docker build --tag rstudioxhost --file xhost/Dockerfile .

# build image based on rocker/verse with many packages installed
docker build --tag rstudioxhost:verse --file xhost/Dockerfile.verse .

# start the container
docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix rstudioxhost

docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix rstudioxhost:verse
```

You can even create one Docker image that has both RStudio variants if you use `rocker/rstudio` as the base image.



## Conclusion

Well, all approaches work... but there is no relevant advantage over running RStudio in the browser using `rocker/rstudio`. As far as my research goes, there is [no](https://support.rstudio.com/hc/en-us/articles/217799198-What-is-the-difference-between-RStudio-Desktop-and-RStudio-Server-) [functional]( https://support.rstudio.com/hc/en-us/articles/200486548-Frequently-Asked-Questions) [difference](https://rud.is/b/2017/04/07/r%E2%81%B6-rstudio-server-client-make-an-app-for-that/) between either [versions](https://www.rstudio.com/products/rstudio/features) (RStudio desktop is indeed a very [lightweight wrapper for a web UI](https://rpubs.com/jmcphers/rstudio-architecture)).

A small advantage could exist using the first approach, at least for users with a high affinity to UIs. They can manage the virtual workspace with a proper desktop besides RStudio.
Things are containerized though, so there is some advantage for reproducibility, if users do not mount relevant stuff into the container.

`x11docker` go to great lengths to handle security issues around exposing an X server, not all of which I can grasp at this point, and hides all that complexity from the user with (probably) sensible defaults.

As pointed out in the blog post discussion [here](http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/#comment-1973698881), Docker is faster than firing up a whole VM and in this case Docker does not only share the Kernel but also the X11 display.

> _"The downside as mentioned a couple places is the security implications of letting the container watch ALL X11 traffic."_

It is left to each users discretion to decide if this works for her.

## License

Rocker's Dockerfiles are licensed under the GPL 2 or later.

x11docker is licensed under the MIT License.

The Dockerfiles and all code in this repository are licensed under the GPL 2 or later (see file `LICENSE`). Non-code objects in this repository are licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
