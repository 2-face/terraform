#===============================================================================
# vSphere Provider
#===============================================================================
provider "vsphere" {
  version        = "1.8.1"
  vsphere_server = "${var.vsphere_vcenter}"
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"

  allow_unverified_ssl = "${var.vsphere_unverified_ssl}"
}

#===============================================================================
# vSphere Data
#===============================================================================

data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_resource_pool" "root_pool" {
  name          = "${var.vsphere_host}/Resources"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vsphere_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.vsphere_port_group}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.vsphere_vm_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

#===============================================================================
# vSphere Resources
#===============================================================================

# Create a vSphere VM folder #
resource "vsphere_folder" "vm_folder_res" {
  path          = "${var.vsphere_vm_folder}"
  type          = "vm"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
  #lifecycle {
  #      ignore_changes = ["path"]
  #  }
}

# Create a vSphere Rancher VM in the folder #
resource "vsphere_virtual_machine" "rancher_vm" {
  # VM placement #
  name             = "${var.vsphere_rancher_vm_name}"
  resource_pool_id = "${data.vsphere_resource_pool.root_pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder           = "${vsphere_folder.vm_folder_res.path}"

  # VM resources #
  num_cpus = "${var.vsphere_vcpu_number}"
  memory   = "${var.vsphere_memory_size}"

  # Guest OS #
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  # VM storage #
  disk {
    label            = "${var.vsphere_rancher_vm_name}.vmdk"
    size             = "${var.vsphere_disk_size}"
    #size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
  }
   
  # Don't power off
  force_power_off = "false"

  # VM networking #
  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  # Customization of the VM #
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = "${var.vsphere_rancher_vm_name}"
        domain    = "${var.vsphere_domain}"
        time_zone = "${var.vsphere_time_zone}"
      }

     network_interface {
        ipv4_address = "${var.vsphere_ipv4_address_rancher_vm}"
        ipv4_netmask = "${var.vsphere_ipv4_netmask}"
      }

      ipv4_gateway    = "${var.vsphere_ipv4_gateway}"
      dns_server_list = ["${var.vsphere_dns_servers}"]
      dns_suffix_list = ["${var.vsphere_domain}"]
    }
  }

  provisioner "file" {
    source      = "${var.rancher_customization_script_path}"
    destination = "/tmp/openstack-rancher.sh"

    connection {
      type     = "ssh"
      user     = "${var.vsphere_vm_template_user}"
      password = "${var.vsphere_vm_template_password}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/openstack-rancher.sh",
      "/tmp/openstack-rancher.sh",
    ]

    connection {
      type     = "ssh"
      user     = "${var.vsphere_vm_template_user}"
      password = "${var.vsphere_vm_template_password}"
    }
  }
}

# Create a vSphere k8s VM in the folder #
resource "vsphere_virtual_machine" "k8s_node" {

  # VM count
  count = "${var.k8s_node_count}"

  # VM placement #
  name             = "${var.vsphere_k8s_node_vm_name}-${count.index}"
  resource_pool_id = "${data.vsphere_resource_pool.root_pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder           = "${vsphere_folder.vm_folder_res.path}"

  # VM resources #
  num_cpus = "${var.vsphere_vcpu_number}"
  memory   = "${var.vsphere_memory_size}"

  # Guest OS #
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  # VM storage #
  disk {
    label            = "${var.vsphere_k8s_node_vm_name}-${count.index}.vmdk"
    size             = "${var.vsphere_disk_size}"
    #size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
  }
   
  # Don't power off
  force_power_off = "false"

  # VM networking #
  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  # Customization of the VM #
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = "${var.vsphere_k8s_node_vm_name}-${count.index}"
        domain    = "${var.vsphere_domain}"
        time_zone = "${var.vsphere_time_zone}"
      }

     network_interface {
        ipv4_address = "${cidrhost("${var.vsphere_ipv4_address_k8s_node_subnet}", count.index)}"
        ipv4_netmask = "${var.vsphere_ipv4_netmask}"
      }

      ipv4_gateway    = "${var.vsphere_ipv4_gateway}"
      dns_server_list = ["${var.vsphere_dns_servers}"]
      dns_suffix_list = ["${var.vsphere_domain}"]
    }
  }

  provisioner "file" {
    source      = "${var.k8s_node_customization_script_path}"
    destination = "/tmp/openstack-k8s-node.sh"
    
    connection {
      type     = "ssh"
      user     = "${var.vsphere_vm_template_user}"
      password = "${var.vsphere_vm_template_password}"
    }
  }

  provisioner "file" {
    source      = "${var.k8s_node_master_nfs_script_path}"
    destination = "/tmp/master_nfs_node.sh"
    
    connection {
      type     = "ssh"
      user     = "${var.vsphere_vm_template_user}"
      password = "${var.vsphere_vm_template_password}"
    }
  }

  provisioner "file" {
    source      = "${var.k8s_node_slave_nfs_script_path}"
    destination = "/tmp/slave_nfs_node.sh"
    
    connection {
      type     = "ssh"
      user     = "${var.vsphere_vm_template_user}"
      password = "${var.vsphere_vm_template_password}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/openstack-k8s-node.sh",
      "/tmp/openstack-k8s-node.sh",
    ]

    connection {
      type     = "ssh"
      user     = "${var.vsphere_vm_template_user}"
      password = "${var.vsphere_vm_template_password}"
    }
  }
}
