# vCenter connection
vsphere_vcenter = "192.168.0.2"

vsphere_user = "Administrator@vsphere.local"

vsphere_password = "P@$$w0rd321!"

vsphere_unverified_ssl = "true"

# VM specifications
vsphere_datacenter = "VCENTER"

vsphere_vm_folder = "k8s-onap"

vsphere_vm_template = "VM_templates/ubuntu-16.04-terraform-template"

vsphere_vm_template_user = "admin"

vsphere_vm_template_password = "P@$$w0rd321!"

vsphere_host = "192.168.100.2"

vsphere_vcpu_number = "8"

vsphere_memory_size = "12228"

vsphere_disk_size = "120"

vsphere_datastore = "datastore1"

vsphere_port_group = "MGMT_PG"

vsphere_ipv4_address_rancher_vm = "192.168.100.20"

vsphere_ipv4_address_k8s_node_subnet = "192.168.100.32/29"

vsphere_ipv4_netmask = "24"

vsphere_ipv4_gateway = "192.168.100.1"

vsphere_dns_servers = "8.8.8.8"

vsphere_domain = "onap"

vsphere_time_zone = "CEST"

k8s_node_count = "3"
