### Base docker ipvlan l3 

set up the server environment, ensure mapping of eth ports to match device. eg. eth0, eno1, etc. 

`./init.sh` should run changes to the host machine `assuming ubuntu server env` and run the `network.yaml` compose file. 

To ensure l3 router has access to the external network and internet run `docker exec -it nat_router ping ....`

Note: you cannot ping host, since it is acting as the router in l3 ipvlan setup, but try google.com or any other device on network.
