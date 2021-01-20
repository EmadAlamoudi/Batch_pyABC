#!/bin/sh
#SBATCH --ntasks=2

# Store passed port
cur_PWD=${1}
PORT=${2}
PYHTONFILE=${3}
TIME=${4}
PARTITION=${5}


cd ${cur_PWD}
# Source Modules
source ./load_module.sh
 
# On torque sometimes we had problems that the job wouldn't know on which node it is currently
sleep 5 

# Find IP of host
HOSTNAME=$(hostname)
HOST_IP=$(host ${HOSTNAME} | awk '{ print $4 }')

# Start Redis server with IP and Port 
srun -n 1 --partition=${PARTITION} --account=fitmulticell /home/ealamoodi/redis-stable/src/./redis-server --bind ${HOST_IP} --port ${PORT} --protected-mode no &


# Start python script
srun -n 1 --partition=${PARTITION} --account=fitmulticell python ${PYHTONFILE} --port ${PORT} --ip ${HOST_IP} > out.txt 2> errpy.txt


