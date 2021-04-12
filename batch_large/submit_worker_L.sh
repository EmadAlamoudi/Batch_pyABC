#!/bin/sh

cur_PWD=${1}
IP=${2}
PORT=${3}
TIME=${4}
CPUSPERTASK=${5}

cd ${cur_PWD}

# Source module
source ./load_module.sh

# Start redis-worker
/p/home/jusers/alamoodi1/juwels/.local/bin/abc-redis-worker --host=${IP} --port ${PORT} --runtime ${TIME:0:2}h --processes ${CPUSPERTASK}


