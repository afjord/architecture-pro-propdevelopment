#!/usr/bin/env bash
set -e

kubectl create namespace development

kubectl run front-end-app --image=nginx --labels role=front-end --expose --port 80 -n development
kubectl run back-end-api-app --image=nginx --labels role=back-end-api --expose --port 80 -n development
kubectl run admin-front-end-app --image=nginx --labels role=admin-front-end --expose --port 80 -n development
kubectl run admin-back-end-api-app --image=nginx --labels role=admin-back-end-api --expose --port 80 -n development
