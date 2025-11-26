#!/bin/bash
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.10.1
kubectl -n longhorn-system get svc,pod
kubectl apply -f longhorn-httproute.yaml
kubectl create -f longhorn-storageclass.yaml


#kubectl create namespace meta
#
#helm repo add grafana https://grafana.github.io/helm-charts
#
#helm install meta-monitoring grafana/meta-monitoring --version 1.3.0 -n meta -f grafana-values.yaml
#
#kubectl get pods -n meta
# est ce que j'ai un dashboard grafana avec longhorn ???
