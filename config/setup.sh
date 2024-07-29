#!/bin/bash

# Enable debugging
set -x
export PATH='/opt/homebrew/bin/'

log_debug() {
    local message="$1"
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
}

# function to create ArgoCD K8s cluster using kind
create_argocd_cluster(){}

# Function to install ArgoCD
install_argocd(){}


# Function to configure ArgoCD
configure_argocd(){}

# Function to create a shared K8s cluster
create_shared_cluster(){}

# Function to add cluster
add_cluster(){}