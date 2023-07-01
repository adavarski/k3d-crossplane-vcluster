#!/bin/bash
MYDIR=$(dirname $0)
k3d cluster delete argo-vcluster
k3d cluster create argo-vcluster -p 8080:80@loadbalancer -v /etc/machine-id:/etc/machine-id:ro -v /var/log/journal:/var/log/journal:ro -v /var/run/docker.sock:/var/run/docker.sock --k3s-arg '--disable=traefik@server:0' --agents 0
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace --set controller.publishService.enabled=true --wait
k3d kubeconfig get argo-vcluster > /tmp/k3d-argo-vcluster.config
export KUBECONFIG=/tmp/k3d-cf-kubecon23-demo.config
helm repo add argo https://argoproj.github.io/argo-helm && helm repo update
# https://github.com/cf-kubecon23-demo/cf-kubecon23-demo/issues/2121
kubectl create ns argocd
cd argocd && ./apply.sh
kubectl -n argocd apply ../ingress-argo.yaml
kubectl -n argocd apply -f ../../argocd-applications


