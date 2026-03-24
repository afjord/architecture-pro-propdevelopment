#!/usr/bin/env bash
set -e

CLUSTER_NAME=minikube
CA_CRT="$HOME/.minikube/ca.crt"
CA_KEY="$HOME/.minikube/ca.key"

create_user() {
  local USERNAME=$1
  local GROUP=$2

  openssl genrsa -out "${USERNAME}.key" 2048
  openssl req -new -key "${USERNAME}.key" -out "${USERNAME}.csr" -subj "/CN=${USERNAME}/O=${GROUP}"

  openssl x509 -req \
    -in "${USERNAME}.csr" \
    -CA "${CA_CRT}" \
    -CAkey "${CA_KEY}" \
    -CAcreateserial \
    -out "${USERNAME}.crt" \
    -days 365

  kubectl config set-credentials "${USERNAME}" \
    --client-certificate="${USERNAME}.crt" \
    --client-key="${USERNAME}.key"

  kubectl config set-context "${USERNAME}@${CLUSTER_NAME}" \
    --cluster="${CLUSTER_NAME}" \
    --user="${USERNAME}"

  echo "Created user ${USERNAME} in group ${GROUP}"
}

create_user dev1 developers
create_user lead1 teamleads
create_user ops1 ops
create_user sec1 security
