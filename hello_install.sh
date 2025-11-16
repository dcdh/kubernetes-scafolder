#!/bin/bash
kubectl create namespace hello
kubectl apply -f hello-ingress.yaml -n hello
kubectl get pods,svc,ingress -n hello
kubectl get svc,gateway -n hello
