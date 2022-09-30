#!/bin/bash
while true
do
    # <CLUSTER_IP>
    curl 35.198.197.192:8080 
    sleep 1
done

kubectl patch deploy simple-app-dep -p '{"spec": {"minReadySeconds": 10}}'
deployment.apps/simple-app-dep patched
