# Homelab Multipass

## Overview

K8s cluster using Multipass, Ansible, and k3s. It provides a basic framework for deploying and managing a Kubernetes cluster on a set of Ubuntu VMs.

## Prerequisites

- Multipass
- Ansible
- k3s

## Setup

```bash
make setup_multipass
make setup_master
make setup_nodes

## OR

make all
```
