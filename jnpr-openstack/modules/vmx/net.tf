data "openstack_networking_network_v2" "MGMT_NET" {
  name = "${var.mgmt_net_name}"
}

data "openstack_networking_subnet_v2" "MGMT_SUBNET" {
  name = "${var.mgmt_subnet_name}"
}

resource "openstack_networking_port_v2" "VMX_VCP_MGMT_PORT" {
  name               = "${var.vmx_vcp_mgmt_port_name}"
  network_id         = "${data.openstack_networking_network_v2.MGMT_NET.id}"
  admin_state_up     = "true"

  fixed_ip = {
    "subnet_id"   = "${data.openstack_networking_subnet_v2.MGMT_SUBNET.id}"
    "ip_address" = "${var.vmx_vcp_mgmt_port_ip}"
  }

  allowed_address_pairs = [
    { ip_address = "0.0.0.0/24"},
    { ip_address = "128.0.0.0/24"},
    { ip_address = "::/120"},
    { ip_address = "8000::/120"}
  ]
}

resource "openstack_networking_port_v2" "VMX_VFP_MGMT_PORT" {
  name               = "${var.vmx_vfp_mgmt_port_name}"
  network_id         = "${data.openstack_networking_network_v2.MGMT_NET.id}"
  admin_state_up     = "true"

  fixed_ip = {
    "subnet_id"   = "${data.openstack_networking_subnet_v2.MGMT_SUBNET.id}"
    "ip_address" = "${var.vmx_vfp_mgmt_port_ip}"
  }

  allowed_address_pairs = [
    { ip_address = "0.0.0.0/24"},
    { ip_address = "128.0.0.0/24"},
    { ip_address = "::/120"},
    { ip_address = "8000::/120"}
  ]
}

resource "openstack_networking_network_v2" "VMX_BASE_NET" {
  name           = "${var.vmx_base_net_name}"
  admin_state_up = "true"
  port_security_enabled = "false"
  #transparent_vlan = "true"
  mtu = "${var.vmx_mtu_base}"
}

resource "openstack_networking_subnet_v2" "VMX_BASE_SUBNET" {
  name       = "${var.vmx_base_subnet_name}"
  network_id = "${openstack_networking_network_v2.VMX_BASE_NET.id}"
  cidr       = "${var.vmx_base_subnet_cidr}"
  ip_version = 4
  enable_dhcp = "false"
}

resource "openstack_networking_port_v2" "VMX_VCP_BASE_PORT" {
  name               = "${var.vmx_vcp_base_port_name}"
  network_id         = "${openstack_networking_network_v2.VMX_BASE_NET.id}"
  admin_state_up     = "true"

  fixed_ip = {
    "subnet_id"  = "${openstack_networking_subnet_v2.VMX_BASE_SUBNET.id}"
    "ip_address" = "${var.vmx_vcp_base_port_ip01}"
  }

  fixed_ip = {
    "subnet_id"  = "${openstack_networking_subnet_v2.VMX_BASE_SUBNET.id}"
    "ip_address" = "${var.vmx_vcp_base_port_ip02}"
  }
}

resource "openstack_networking_port_v2" "VMX_VFP_BASE_PORT" {
  name               = "${var.vmx_vfp_base_port_name}"
  network_id         = "${openstack_networking_network_v2.VMX_BASE_NET.id}"
  admin_state_up     = "true"

  fixed_ip = {
    "subnet_id"  = "${openstack_networking_subnet_v2.VMX_BASE_SUBNET.id}"
    "ip_address" = "${var.vmx_vfp_base_port_ip01}"
  }
}

data "openstack_networking_network_v2" "VMX_VFP_NS_NET_TEN" {
  count = "${var.vmx_ns_net_ten_count}"
  name  = "${var.vmx_ns_net_ten["net_name_${count.index}"]}"
}

data "openstack_networking_subnet_v2" "VMX_VFP_NS_SUBNET_TEN" {
  count = "${var.vmx_ns_net_ten_count}"
  name  = "${var.vmx_ns_net_ten["subnet_name_${count.index}"]}"
}

resource "openstack_networking_port_v2" "VMX_VFP_NS_PORT_TEN" {
  count              = "${var.vmx_ns_net_ten_count}"
  name               = "${var.vmx_ns_net_ten["port_name_${count.index}"]}"
  network_id         = "${element(data.openstack_networking_network_v2.VMX_VFP_NS_NET_TEN.*.id, count.index)}"
  admin_state_up     = "true"

  fixed_ip = {
    "subnet_id"  = "${element(data.openstack_networking_subnet_v2.VMX_VFP_NS_SUBNET_TEN.*.id, count.index)}"
    "ip_address" = "${var.vmx_ns_net_ten["port_ip_${count.index}"]}"
  }
}

data "openstack_networking_network_v2" "VMX_VFP_NS_NET_PROV" {
  count = "${var.vmx_ns_net_prov_count}"
  name  = "${var.vmx_ns_net_prov["net_name_${count.index}"]}"
}

data "openstack_networking_subnet_v2" "VMX_VFP_NS_SUBNET_PROV" {
  count = "${var.vmx_ns_net_prov_count}"
  name  = "${var.vmx_ns_net_prov["subnet_name_${count.index}"]}"
}

resource "openstack_networking_port_v2" "VMX_VFP_NS_PORT_PROV" {
  count              = "${var.vmx_ns_net_prov_count}"
  name               = "${var.vmx_ns_net_prov["port_name_${count.index}"]}"
  network_id         = "${element(data.openstack_networking_network_v2.VMX_VFP_NS_NET_PROV.*.id, count.index)}"
  admin_state_up     = "true"

  fixed_ip = {
    "subnet_id"  = "${element(data.openstack_networking_subnet_v2.VMX_VFP_NS_SUBNET_PROV.*.id, count.index)}"
    "ip_address" = "${var.vmx_ns_net_prov["port_ip_${count.index}"]}"
  }
}