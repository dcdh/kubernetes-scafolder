#!/bin/bash
kubectl create namespace meta

helm repo add grafana https://grafana.github.io/helm-charts

helm install meta-monitoring grafana/meta-monitoring --version 1.3.0 -n meta -f grafana-values.yaml

kubectl get pods -n meta
