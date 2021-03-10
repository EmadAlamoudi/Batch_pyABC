#!/bin/sh
#SBATCH --ntasks=3

# Store passed port
cur_PWD=${1}
PORT=${2}
PYHTONFILE=${3}
TIME=${4}
CPUSPERTASK=${5}
PARTITION=${6}


cd ${cur_PWD}
# Source Modules
source ./load_module.sh
 
# On torque sometimes we had problems that the job wouldn't know on which node it is currently
sleep 5 

# Find IP of host
HOSTNAME=$(hostname)
HOST_IP=$(host ${HOSTNAME} | awk '{ print $4 }')

# Start Redis server with IP and Port 
srun -n 1 --partition=${PARTITION} --account=fitmulticell /home/ealamoodi/redis-stable/src/./redis-server --port ${PORT} --protected-mode no &


# Start python script
srun -n 1 --partition=${PARTITION} --account=fitmulticell python ${PYHTONFILE} --port ${PORT} --ip ${HOST_IP} > out.txt 2> errpy.txt &

# Start redis-worker
WORKER_CPUSPERTASK=$((${CPUSPERTASK}-2))
echo ${WORKER_CPUSPERTASK}
srun -n ${WORKER_CPUSPERTASK} --partition=${PARTITION} --account=fitmulticell /home/ealamoodi/.local/bin/abc-redis-worker --host=${HOST_IP} --port ${PORT} --runtime ${TIME:0:2}h --processes ${WORKER_CPUSPERTASK}


