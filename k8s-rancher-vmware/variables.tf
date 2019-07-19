# vCenter connection

variable "vsphere_user" {
  description = "vSphere user name"
}

variable "vsphere_password" {
  description = "vSphere password"
}

variable "vsphere_vcenter" {
  description = "vCenter server FQDN or IP"
}

variable "vsphere_unverified_ssl" {
  description = "Is the vCenter using a self signed certificate (true/false)"
}

# VM specifications

variable "vsphere_datacenter" {
  description = "In which datacenter the VM will be deployed"
}

variable "vsphere_rancher_vm_name" {
  default = "onap-rancher-vm"
}

variable "vsphere_k8s_node_vm_name" {
  default = "onap-k8s-node-vm"
}

variable "vsphere_vm_template" {
  description = "Where is the VM template located"
}

variable "vsphere_vm_folder" {
  description = "In which folder the VM will be store"
}

variable "vsphere_host" {
  description = "In which host the VM will be deployed"
}

variable "vsphere_vcpu_number" {
  description = "How many vCPU will be assigned to the VM (default: 1)"
  default     = "1"
}

variable "vsphere_memory_size" {
  description = "How much RAM will be assigned to the VM (default: 1024)"
  default     = "1024"
}
variable "vsphere_disk_size" {
  description = "How much disk will be assigned to the VM (default: 1GB)"
  default     = "1"
}

variable "vsphere_datastore" {
  description = "What is the name of the VM datastore"
}

variable "vsphere_port_group" {
  description = "In which port group the VM NIC will be configured (default: VM Network)"
  default     = "VM Network"
}

variable "vsphere_ipv4_address_rancher_vm" {
  description = "What is the IPv4 address of the Rancher VM"
}

variable "vsphere_ipv4_address_k8s_node_subnet" {
  description = "What is the k8s node subnet"
}

variable "vsphere_ipv4_netmask" {
  description = "What is the IPv4 netmask of the VM (default: 24)"
  default     = "24"
}

variable "vsphere_ipv4_gateway" {
  description = "What is the IPv4 gateway of the VM"
}

variable "vsphere_dns_servers" {
  description = "What are the DNS servers of the VM (default: 8.8.8.8,5.5.5.5)"
  default     = "8.8.8.8,5.5.5.5"
}

variable "vsphere_domain" {
  description = "What is the domain of the VM"
}

variable "vsphere_time_zone" {
  description = "What is the timezone of the VM (default: UTC)"
  default     = "UTC"
}

variable "rancher_customization_script_path" {
  default = "./scripts/openstack-rancher.sh"
}

variable "k8s_node_customization_script_path" {
  default = "./scripts/openstack-k8s-node.sh"
}

variable "k8s_node_master_nfs_script_path" {
  default = "./scripts/master_nfs_node.sh"
}

variable "k8s_node_slave_nfs_script_path" {
  default = "./scripts/slave_nfs_node.sh"
}

variable "k8s_node_count" {
  default = "3"
}

variable "vsphere_vm_template_user" {
}

variable "vsphere_vm_template_password" {
}