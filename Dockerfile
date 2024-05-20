FROM mambaorg/micromamba:1.5.8

# Change user, from
ARG NEW_MAMBA_USER=new-username
ARG NEW_MAMBA_USER_ID=57440
ARG NEW_MAMBA_USER_GID=57440
USER root

RUN if grep -q '^ID=alpine$' /etc/os-release; then \
    # alpine does not have usermod/groupmod
    apk add --no-cache --virtual temp-packages shadow; \
    fi && \
    usermod "--login=${NEW_MAMBA_USER}" "--home=/home/${NEW_MAMBA_USER}" \
    --move-home "-u ${NEW_MAMBA_USER_ID}" "${MAMBA_USER}" && \
    groupmod "--new-name=${NEW_MAMBA_USER}" \
    "-g ${NEW_MAMBA_USER_GID}" "${MAMBA_USER}" && \
    if grep -q '^ID=alpine$' /etc/os-release; then \
    # remove the packages that were only needed for usermod/groupmod
    apk del temp-packages; \
    fi && \
    # Update the expected value of MAMBA_USER for the
    # _entrypoint.sh consistency check.
    echo "${NEW_MAMBA_USER}" > "/etc/arg_mamba_user" && \
    :
ENV MAMBA_USER=$NEW_MAMBA_USER
USER $MAMBA_USER

COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yaml /tmp/env.yaml
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes

# Allow environment to be activated
ARG MAMBA_DOCKERFILE_ACTIVATE=1
ENV CONDA_DEFAULT_ENV base
ENV PATH "$MAMBA_ROOT_PREFIX/bin:$PATH"
