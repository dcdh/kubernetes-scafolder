#!/bin/bash
kubectl delete namespace hello
kubectl create namespace hello
kubectl apply -f hello-app.yaml -n hello
kubectl get pods,svc,gateway,ingress -n hello
