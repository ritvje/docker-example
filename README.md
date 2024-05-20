# Example Docker container

This repository contains a basic Docker configuration for running conda environments in a container. It is intended to be used as a starting point for building containers for (weather radar) applications.

The container is based on the `mambaorg/micromamba:1-alpine` image. Container size optimizations are from [this](https://uwekorn.com/2021/03/01/deploying-conda-environments-in-docker-how-to-do-it-right.html) and [this](https://jcristharif.com/conda-docker-tips.html) blog posts.

## Usage:

1. Update the conda environment file `environment.yml` with the correct packages.
2. Update Dockerfile with correct user information, if needed. (User and group id can be found with `id -u` and `id -g` commands.)

   ```Dockerfile
    ARG NEW_MAMBA_USER=<username>
    ARG NEW_MAMBA_USER_ID=<user-id>
    ARG NEW_MAMBA_USER_GID=<group-id>
   ```

3. Update the `docker-compose.yml` file with correct mount paths.
4. Build and run the container as described below.

## With `docker compose`

```bash
docker compose run --rm radar-app
```

## Build and run manually

```bash
# Build
docker buildx build --pull --rm -f "Dockerfile" -t docker:latest "."

# Run
docker run --rm -it --entrypoint /bin/bash -w /code docker:latest
```

## In VSCode

1. Install the Docker extension.
2. Open the repository in VSCode.
3. Right-click on the `docker-compose.yml` file and select `Compose Up`.
4. Go to Docker tab and right-click on the container and select `Attaach shell`.
