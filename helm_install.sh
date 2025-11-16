#!/bin/bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh
# https://docs.cilium.io/en/latest/network/servicemesh/gateway-api/gateway-api/
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.3.0/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.3.0/config/crd/standard/gateway.networking.k8s.io_gateways.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.3.0/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.3.0/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.3.0/config/crd/standard/gateway.networking.k8s.io_grpcroutes.yaml
helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium --version 1.18.2 --namespace kube-system --create-namespace --set operator.replicas=1 --set kubeProxyReplacement=true --set encryption.enabled=true --set encryption.nodeEncryption=true --set encryption.type=wireguard --set ingressController.enabled=false --set ingressController.loadBalancerMode=dedicated --set gatewayAPI.enabled=true --set nodePort.enabled=true
kubectl get pod -A
kubectl apply -f cilium.yaml
