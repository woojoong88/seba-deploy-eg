#! /usr/bin/env bash

echo "Deploy CORD Helm charts - 2. SimpleExampleService"

cd ~/cord/helm-charts
sudo helm dep update xos-profiles/demo-simpleexampleservice
sudo helm install xos-profiles/demo-simpleexampleservice -n demo-simpleexampleservice
