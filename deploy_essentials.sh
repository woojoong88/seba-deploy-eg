#! /usr/bin/env bash

echo "Deploy CORD Helm charts - 1. essentials"

cd ~/cord/helm-charts
sudo helm init
sudo helm dep update xos-core
sudo helm install xos-core -n xos-core
sudo helm dep update xos-profiles/base-kubernetes
sudo helm install xos-profiles/base-kubernetes -n base-kubernetes
