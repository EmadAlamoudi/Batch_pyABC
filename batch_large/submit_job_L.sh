#!/bin/sh
# Master script


PORT=${1}
N_NODES=${2}
PARTITION=${3}
TIME=${4}
CPUSPERTASK=${5}
PYTHONFILE=${6}
DB=${7}
MODEL=${8}
POPULATION=${9}


echo '#### PORT= ####'${PORT}
echo '#### N_NODES= ####'${N_NODES}
echo '#### PARTITION= ####'${PARTITION}
echo '#### TIME= ####'${TIME}
echo '#### CPUSPERTASK= ####'${CPUSPERTASK}

echo '#### PYTHONFILE= ####'${PYTHONFILE}
echo '#### DB= ####'${DB}

echo '#### MODEL= ####'${MODEL}
echo '#### POPULATION= ####'${POPULATION}

if [ -z "${N_NODES}" ]
then
        N_NODES=1
fi

# Soruce Modules
source ./load_module.sh

# Submit redis 
srun --nodes=1 --ntasks=1 --cpus-per-task=${CPUSPERTASK} bash -c 'hostname > master_ip && /p/project/fitmulticell/emad/Koco19/set_1/submit_redis_L.sh $0 $1' ${PWD} ${PORT} > redis_output.txt&
# Wait for redis to start
sleep 10

IP_long=`cat master_ip | tr '\n' ' '`
IP="${IP_long%%.*}"
MASTER_IP=`getent hosts ${IP}i | cut -d' ' -f1`
echo "IP_long: $IP_long "
echo "IP: $IP "
echo "MASTER_IP: $MASTER_IP "
# On PBS/Torque I had a while loop here that checked when the status of the job switched to RUNNING
# Retrieve compute node of that job ID
# COMP_NODE=$(squeue | grep ${JOB_ID} | awk '{ print $8 }')

# Retrieve IP of compute node
# REDIS_IP=$(host ${COMP_NODE}i | awk '{ print $4 }')
# echo 'COMP_NODE:' ${COMP_NODE}
# echo 'Redis IP:' ${REDIS_IP}
echo 'Total number of requested nodes = '$((${N_NODES}))
# Start python script
srun --nodes=1 --ntasks=1 --cpus-per-task=${CPUSPERTASK} submit_python_L.sh ${PWD} ${MASTER_IP} ${PORT} ${PYTHONFILE} ${DB} ${MODEL} ${POPULATION} ${TIME} > python_output.txt &

echo 'Python script is running'

# Start redis-worker
# srun -N $((${N_NODES}-1)) /p/home/jusers/alamoodi1/juwels/.local/bin/abc-redis-worker --host=${IP} --port ${PORT} --runtime ${TIME:0:2}h --processes ${CPUSPERTASK}
for i in $(seq 4 ${N_NODES})
do
    srun --nodes=1 --ntasks=1 --cpus-per-task=${CPUSPERTASK} submit_worker_L.sh ${PWD} ${MASTER_IP} ${PORT} ${TIME} ${CPUSPERTASK} &

done
srun --nodes=1 --ntasks=1 --cpus-per-task=${CPUSPERTASK} submit_worker_L.sh ${PWD} ${MASTER_IP} ${PORT} ${TIME} ${CPUSPERTASK}






