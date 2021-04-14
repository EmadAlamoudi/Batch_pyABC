#!/bin/sh

cur_PWD=${1}
IP=${2}
PORT=${3}
PYHTONFILE=${4}
DB=${5}
MODEL=${6}
POPULATION=${7}
TIME=${8}

cd ${cur_PWD}

# Source module
source ./load_module.sh

# Start redis-worker
python ${PYHTONFILE} --ip ${IP} --port ${PORT}


