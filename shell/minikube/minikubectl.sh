#!/bin/bash

set -e

PORT=${2:-5432}
case "$1" in
  "start" )
	minikube start --mount --mount-string="/Users/arun.koshi/:/Users/arun.koshi/" --memory 6144 --cpus 4 --driver hyperkit --no-kubernetes
    ;;

  "stop" )
    minikube stop
    ;;

  "ip" )
    minikube ip
    ;;

  "ssh" )
    minikube ssh
    ;;

  "port-forward-start" )
 	ssh -M -S ~/.ssh/my-docker-ssh-db-tunnel-$PORT -fnNT -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i $(minikube ssh-key) docker@$(minikube ip) -L $PORT:localhost:$PORT
 	;;

  "port-forward-check" )
 	ssh -S ~/.ssh/my-docker-ssh-db-tunnel-$PORT -O check -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i $(minikube ssh-key) docker@$(minikube ip)
 	;;

  "port-forward-stop" )
 	ssh -S ~/.ssh/my-docker-ssh-db-tunnel-$PORT -O exit -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i $(minikube ssh-key) docker@$(minikube ip)
 	;;

  "prune-all" )
	minikube delete --all --purge
	;;

  *)
    echo "Error: Missing or invalid parameter"
    exit 1
    ;;
esac
