#!/bin/bash

NB_PREFIX=${NB_PREFIX:-"/"}

export GRANT_SUDO='yes'
export RESTARTABLE='yes'

start.sh jupyter lab \
--LabApp.token='' \
--LabApp.password='' \
--LabApp.allow_origin='*' \
--LabApp.base_url=${NB_PREFIX} \
--ip=0.0.0.0 \
--port=8888 \
--notebook-dir=/home/jovyan \
--allow-root \
--no-browser
