FROM mambaorg/micromamba:1-alpine
ENV conda_env base
RUN mkdir /home/mambauser/${conda_env}
COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yaml /tmp/env.yaml
ENV PYTHONDONTWRITEBYTECODE=true
# For reference for cleanup, see https://uwekorn.com/2021/03/01/deploying-conda-environments-in-docker-how-to-do-it-right.html
# and https://jcristharif.com/conda-docker-tips.html
RUN --mount=type=cache,target=/opt/conda/pkgs micromamba install -y --file env.yaml --freeze-installed \
    && micromamba clean -afy \
    && find -name '*.a' -delete \
    && rm -rf /opt/conda/conda-meta \
    && rm -rf /opt/conda/include \
    && rm /opt/conda//lib/libpython*.so.1.0 \
    && find -name '__pycache__' -type d -exec rm -rf '{}' '+' \
    && rm -rf /opt/conda/lib/python3.9/site-packages/pip /opt/conda/lib/python3.9/idlelib /opt/conda/lib/python3.9/ensurepip \
    /opt/conda/lib/libasan.so.5.0.0 \
    /opt/conda/lib/libtsan.so.0.0.0 \
    /opt/conda/lib/liblsan.so.0.0.0 \
    /opt/conda/lib/libubsan.so.1.0.0 \
    /opt/conda/bin/x86_64-conda-linux-gnu-ld \
    /opt/conda/bin/sqlite3 \
    /opt/conda/bin/openssl \
    /opt/conda/share/terminfo \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.pyc' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -follow -type f -name '*.js' ! -name '*.min.js' -delete \
    && find /opt/conda/lib/python*/site-packages/scipy -name 'tests' -type d -exec rm -rf '{}' '+' \
    && find /opt/conda/lib/python*/site-packages/numpy -name 'tests' -type d -exec rm -rf '{}' '+' \
    && find /opt/conda/lib/python*/site-packages/pandas -name 'tests' -type d -exec rm -rf '{}' '+' \
    && find /opt/conda/lib/python*/site-packages -name '*.pyx' -delete \
    && rm -rf /opt/conda/lib/python*/site-packages/uvloop/loop.c

# Allow environment to be activated
ENV PATH /opt/conda/envs/$conda_env/bin:$PATH
ENV CONDA_DEFAULT_ENV $conda_env

COPY . /code
WORKDIR /code

ENTRYPOINT /bin/bash