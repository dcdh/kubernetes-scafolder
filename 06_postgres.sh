#!/bin/bash
helm repo add cnpg https://cloudnative-pg.github.io/charts

helm upgrade --install cnpg --namespace cnpg-system --create-namespace cnpg/cloudnative-pg --version 0.26.1

helm upgrade --install database --namespace database --create-namespace cnpg/cluster --set cluster.instances=1 --set cluster.storage.storageClass="longhorn-test"
