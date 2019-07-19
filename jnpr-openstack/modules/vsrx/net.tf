data "openstack_networking_network_v2" "MGMT_NET" {
  name = "${var.mgmt_net_name}"
}

data "openstack_networking_subnet_v2" "MGMT_SUBNET" {
  name = "${var.mgmt_subnet_name}"
}

resource "openstack_networking_port_v2" "VSRX_MGMT_PORT" {
  name               = "${var.vsrx_mgmt_port_name}"
  network_id         = "${data.openstack_networking_network_v2.MGMT_NET.id}"
  admin_state_up     = "true"

  fixed_ip = {
    "subnet_id"   = "${data.openstack_networking_subnet_v2.MGMT_SUBNET.id}"
    "ip_address" = "${var.vsrx_mgmt_port_ip}"
  }

  allowed_address_pairs = [
    { ip_address = "0.0.0.0/24"},
    { ip_address = "128.0.0.0/24"},
    { ip_address = "::/120"},
    { ip_address = "8000::/120"}
  ]
}

data "openstack_networking_network_v2" "VSRX_NS_NET_TEN" {
  count = "${var.vsrx_ns_net_ten_count}"
  name  = "${var.vsrx_ns_net_ten["net_name_${count.index}"]}"
}

data "openstack_networking_subnet_v2" "VSRX_NS_SUBNET_TEN" {
  count = "${var.vsrx_ns_net_ten_count}"
  name  = "${var.vsrx_ns_net_ten["subnet_name_${count.index}"]}"
}

resource "openstack_networking_port_v2" "VSRX_NS_PORT_TEN" {
  count              = "${var.vsrx_ns_net_ten_count}"
  name               = "${var.vsrx_ns_net_ten["port_name_${count.index}"]}"
  network_id         = "${element(data.openstack_networking_network_v2.VSRX_NS_NET_TEN.*.id, count.index)}"
  admin_state_up     = "true"

  fixed_ip = {
    "subnet_id"  = "${element(data.openstack_networking_subnet_v2.VSRX_NS_SUBNET_TEN.*.id, count.index)}"
    "ip_address" = "${var.vsrx_ns_net_ten["port_ip_${count.index}"]}"
  }
}

data "openstack_networking_network_v2" "VSRX_NS_NET_PROV" {
  count = "${var.vsrx_ns_net_prov_count}"
  name  = "${var.vsrx_ns_net_prov["net_name_${count.index}"]}"
}

data "openstack_networking_subnet_v2" "VSRX_NS_SUBNET_PROV" {
  count = "${var.vsrx_ns_net_prov_count}"
  name  = "${var.vsrx_ns_net_prov["subnet_name_${count.index}"]}"
}

resource "openstack_networking_port_v2" "VSRX_NS_PORT_PROV" {
  count              = "${var.vsrx_ns_net_prov_count}"
  name               = "${var.vsrx_ns_net_prov["port_name_${count.index}"]}"
  network_id         = "${element(data.openstack_networking_network_v2.VSRX_NS_NET_PROV.*.id, count.index)}"
  admin_state_up     = "true"

  fixed_ip = {
    "subnet_id"  = "${element(data.openstack_networking_subnet_v2.VSRX_NS_SUBNET_PROV.*.id, count.index)}"
    "ip_address" = "${var.vsrx_ns_net_prov["port_ip_${count.index}"]}"
  }
}