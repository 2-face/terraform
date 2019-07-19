provider "openstack" {
    user_name = "${var.osp_user_name}"
    user_domain_name = "${var.osp_user_domain_name}"
    tenant_name = "${var.osp_project_name}"
    project_domain_name = "${var.osp_project_domain_name}"
    password = "${var.osp_user_pass}"
    auth_url = "${var.osp_auth_url}"
    region = "${var.osp_region}"
}

#Tenant networks
resource "openstack_networking_network_v2" "NS_NET_TEN" {
  count          = "${var.ns_net_ten_count}"
  name           = "${var.ns_net_ten["net_name_${count.index}"]}"
  admin_state_up = "true"
  region         = "${var.osp_region}"
  port_security_enabled = "false"
  #transparent_vlan = "true"
  mtu = "${var.mtu_ns}"  
}
resource "openstack_networking_subnet_v2" "NS_SUBNET_TEN" {
  count      = "${var.ns_net_ten_count}"
  name       = "${var.ns_net_ten["subnet_name_${count.index}"]}"
  network_id = "${element(openstack_networking_network_v2.NS_NET_TEN.*.id, count.index)}"
  cidr       = "${var.ns_net_ten["subnet_cidr_${count.index}"]}"
  ip_version = 4
  enable_dhcp = "false"
  no_gateway  = "true"
}

#Provider networks
resource "openstack_networking_network_v2" "NS_NET_PROV" {
  count          = "${var.ns_net_prov_count}"
  name           = "${var.ns_net_prov["net_name_${count.index}"]}"
  admin_state_up = "true"
  region         = "${var.osp_region}"
  port_security_enabled = "false"
  #transparent_vlan = "true"
  mtu = "${var.mtu_ns}"

  segments = [
    {
      physical_network = "${var.ns_net_prov["net_physical_net_${count.index}"]}"
      network_type = "${var.ns_net_prov["net_type_${count.index}"]}"
      segmentation_id = "${var.ns_net_prov["net_segmentation_id_${count.index}"]}"
    }
  ]
}
resource "openstack_networking_subnet_v2" "NS_SUBNET_PROV" {
  count      = "${var.ns_net_prov_count}"
  name       = "${var.ns_net_prov["subnet_name_${count.index}"]}"
  network_id = "${element(openstack_networking_network_v2.NS_NET_PROV.*.id, count.index)}"
  cidr       = "${var.ns_net_prov["subnet_cidr_${count.index}"]}"
  ip_version = 4
  enable_dhcp = "false"
  no_gateway  = "true"
}

#Tenant networks
resource "openstack_networking_network_v2" "EW_NET_TEN" {
  count          = "${var.ew_net_ten_count}"
  name           = "${var.ew_net_ten["net_name_${count.index}"]}"
  admin_state_up = "true"
  region         = "${var.osp_region}"
  port_security_enabled = "false"
  #transparent_vlan = "true"
  mtu = "${var.mtu_ew}"  
}
resource "openstack_networking_subnet_v2" "EW_SUBNET_TEN" {
  count      = "${var.ew_net_ten_count}"
  name       = "${var.ew_net_ten["subnet_name_${count.index}"]}"
  network_id = "${element(openstack_networking_network_v2.EW_NET_TEN.*.id, count.index)}"
  cidr       = "${var.ew_net_ten["subnet_cidr_${count.index}"]}"
  ip_version = 4
  enable_dhcp = "false"
  no_gateway  = "true"
}

#Provider networks
resource "openstack_networking_network_v2" "EW_NET_PROV" {
  count          = "${var.ew_net_prov_count}"
  name           = "${var.ew_net_prov["net_name_${count.index}"]}"
  admin_state_up = "true"
  region         = "${var.osp_region}"
  port_security_enabled = "false"
  #transparent_vlan = "true"
  mtu = "${var.mtu_ew}"

  segments = [
    {
      physical_network = "${var.ew_net_prov["net_physical_net_${count.index}"]}"
      network_type = "${var.ew_net_prov["net_type_${count.index}"]}"
      segmentation_id = "${var.ew_net_prov["net_segmentation_id_${count.index}"]}"
    }
  ]
}
resource "openstack_networking_subnet_v2" "EW_SUBNET_PROV" {
  count      = "${var.ew_net_prov_count}"
  name       = "${var.ew_net_prov["subnet_name_${count.index}"]}"
  network_id = "${element(openstack_networking_network_v2.EW_NET_PROV.*.id, count.index)}"
  cidr       = "${var.ew_net_prov["subnet_cidr_${count.index}"]}"
  ip_version = 4
  enable_dhcp = "false"
  no_gateway  = "true"
}