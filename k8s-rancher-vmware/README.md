# Kubernetes with Rancher on ESXi

## Table of Contents
+ [About](#about)
+ [Getting Started](#getting_started)
+ [Usage](#usage)
+ [Author](#author)

## About <a name = "about"></a>
Terraform scripts in this repo are built from instruction for setting up k8s with Rancher on Openstack for ONAP - Open Network Automation Platform, Casablanca Release - [ONAP on Kubernetes with Rancher](https://onap.readthedocs.io/en/casablanca/submodules/oom.git/docs/oom_setup_kubernetes_rancher.html#onap-on-kubernetes-with-rancher). Instead of setting up the environment on OpenStack it was setup on VMware's ESXi.

## Getting Started <a name = "getting_started"></a>

### Prerequisites
Following prerequisites must be met to run this tutorial (*tested environment*):
- [Terraform 0.11.13](https://www.terraform.io/downloads.html)
- VMware ESXI 6.5 or higher
- Management Port Group available in ESXi
- vCenter
- Ubuntu 16.04

### Installing
K8s nodes are setup on Ubuntu 16.04 which is a standard image but installed, provisioned with a user, networking configuration and saved as a template in vCenter. Instruction on how to create a template can be found under the [link](https://blog.inkubate.io/install-and-manage-automatically-a-kubernetes-cluster-on-vmware-vsphere-with-terraform-and-kubespray/).

### Architecture
Setup consists of:
- a rancher VM (k8s control plane + rancher addons)
- a number of k8s worker nodes
- common NFS storage spread across worker nodes (slaves) with rancher VM acting as master NFS node

![](https://onap.readthedocs.io/en/casablanca/_images/k8s-topology.jpg)


## Usage <a name = "usage"></a>
### Deploy VNFs
Initialize terraform (it will preverify files, dependencies, download modules)
```shell-session
terraform init
```

Check what is the planned infrastructure
```shell-session
terraform plan
```

If planned infrastructure is fine then deploy it
```shell-session
terraform apply
```
*`Any resources created manually after this step must be also manually destroyed since infra state will not match the actual state`*

**Clean Up**
>Anything created manually with **terraform apply** must be removed manually. When that is done destroy the infra as easy as
```shell-session
terraform destroy
```
>Resources can be destroyed per module as well (e.g. remove VNFs but keep images and networks)
```shell-session
terraform destroy -target=module.vmx01 -target=module.vsrx01
```


## Author <a name = "author"></a>
[LinkedIn](https://www.linkedin.com/in/mazurekmichal/)
<br></br>
[Website](http://www.stackblog.net/)


