# Batch_pyABC

Batch scripts to allow dynamically allocate master/worker nodes for the redis implementation in pyABC

## Start a parallel pyABC run:
run `submit_job.sh` with the follwing parameters:
* port number
* Number of nodes
* queue name
* job time 
* CPUSPERTASK
* python script
## To kill all running jobs:
run `kill_all.sh`

Please note that you need to change the python file to take two arguments (the `port_number` and the `host_id`). This can be done using the `argparse` package.
