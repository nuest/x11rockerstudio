# RStudio Desktop in container

This repository contains some tests to run [RStudio](http://rstudio.com/) Desktop, an IDE for [R](https://r-project.org), in a container.

It is based on [Rocker](https://github.com/rocker-org/rocker) and/or [x11docker](https://github.com/mviereck/x11docker).

Two approaches are evaluated here:

- using `x11docker/lxde` base image, installing R + RStudio
- using `rocker/verse`, installing the UI and stuff according to x11docker's Dockerfile, and install RStudio

Both approaches use Debian base images, which helps a lot.

## Results

### x11docker base image

The following commands require x11docker to be install (clone the repo, then run `sudo x11docker --install`). If you prefer not to do that, add the full path to `x11docker` binary in the commands below.

```bash
docker build --tag x11rockerstudio  --file x11docker-base/Dockerfile .

# for testing: docker run --rm -it --entrypoint /bin/bash x11docker/lxde

# start container with LXDE desktop:
x11docker --desktop --sudo --net --clipboard x11rockerstudio

# start container and only start RStudio
x11docker --desktop --sudo --net --clipboard x11rockerstudio /usr/lib/rstudio/bin/rstudio
```

### Rocker base image

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

## Conclusion

Well, it works... but there is no relevant advantage over running RStudio in the browser using `rocker/rstudio`.

A small advantage could exist for users with a high affinity to UIs, who can manage the virtual workspace with a proper desktop.
Things are containerized though, so there is some plus for reproducibility.

`x11docker` go to great lengths to handle security issues around exposing an X server, not all of which I can grasp at this point, and hides all that complexity from the user with (probably) sensible defaults.

## License

Rocker's Dockerfiles are licensed under the GPL 2 or later.

x11docker is licensed under the MIT License.

The Dockerfiles and all code in this repository are licensed under the GPL 2 or later (see file `LICENSE`). Non-code objects in this repository are licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
