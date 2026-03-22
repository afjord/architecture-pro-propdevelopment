#!/usr/bin/env bash
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

kubectl create namespace sales-team --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace tenant-team --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace finance-team --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f "${SCRIPT_DIR}/roles.yaml"