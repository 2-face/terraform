provider "template" {}

provider "external" {}

provider "null" {}

provider "openstack" {
    user_name = "${var.osp_user_name}"
    user_domain_name = "${var.osp_user_domain_name}"
    tenant_name = "${var.osp_project_name}"
    project_domain_name = "${var.osp_project_domain_name}"
    password = "${var.osp_user_pass}"
    auth_url = "${var.osp_auth_url}"
    region = "${var.osp_region}"
}

module "img" {
    source = "./modules/img"

    #Openstack connectivity
    osp_user_name = "${var.osp_user_name}"
    osp_user_domain_name = "${var.osp_user_domain_name}"
    osp_project_name = "${var.osp_project_name}"
    osp_project_domain_name = "${var.osp_project_domain_name}"
    osp_user_pass = "${var.osp_user_pass}"
    osp_auth_url = "${var.osp_auth_url}"
    osp_region = "${var.osp_region}"

    # Visibility of the created resources
    resource_visibility = "${var.resource_visibility}"

    vmx_vcp_image_name = "${var.vm_imgs["vmx_vcp_image_name"]}"
    vmx_vcp_image_path = "${var.vm_imgs["vmx_vcp_image_path"]}"
    vmx_vcp_flav_name = "${var.vm_imgs["vmx_vcp_flav_name"]}"

    vmx_vfp_image_name = "${var.vm_imgs["vmx_vfp_image_name"]}"
    vmx_vfp_image_path = "${var.vm_imgs["vmx_vfp_image_path"]}"
    vmx_vfp_flav_name = "${var.vm_imgs["vmx_vfp_flav_name"]}"

    vsrx_image_name = "${var.vm_imgs["vsrx_image_name"]}"
    vsrx_image_path = "${var.vm_imgs["vsrx_image_path"]}"
    vsrx_flav_name = "${var.vm_imgs["vsrx_flav_name"]}"
}

module "net" {
    source = "./modules/net"

    #Openstack connectivity
    osp_user_name = "${var.osp_user_name}"
    osp_user_domain_name = "${var.osp_user_domain_name}"
    osp_project_name = "${var.osp_project_name}"
    osp_project_domain_name = "${var.osp_project_domain_name}"
    osp_user_pass = "${var.osp_user_pass}"
    osp_auth_url = "${var.osp_auth_url}"
    osp_region = "${var.osp_region}"

    # Visibility of the created resources
    resource_visibility = "${var.resource_visibility}"

    mtu_ns = "${var.mtu_ns}"
    mtu_ew = "${var.mtu_ew}"

    #NS/EW tenant networks
    ns_net_ten_count = "${var.ns_net_ten_count}"
    ns_net_ten = {

      net_name_0 = "${var.ns_net_ten["p2p_vmx01_vsrx01_net_name"]}"
      subnet_name_0 = "${var.ns_net_ten["p2p_vmx01_vsrx01_subnet_name"]}"
      subnet_cidr_0 = "${var.ns_net_ten["p2p_vmx01_vsrx01_subnet_cidr"]}"
      
    }

    ew_net_ten_count = "${var.ew_net_ten_count}"
    ew_net_ten = {}

    #NS/EW provider networks (going via external router/ToR)
    ns_net_prov_count = "${var.ns_net_prov_count}"
    ns_net_prov = {

      net_name_0 = "${var.ns_net_prov["p2p_vmx01_rtr01_net_name"]}"
      net_type_0 = "${var.ns_net_prov["p2p_vmx01_rtr01_net_type"]}"
      net_physical_net_0 = "${var.ns_net_prov["p2p_vmx01_rtr01_net_physical_net"]}"
      net_segmentation_id_0 = "${var.ns_net_prov["p2p_vmx01_rtr01_net_segmentation_id"]}"
      subnet_name_0 = "${var.ns_net_prov["p2p_vmx01_rtr01_subnet_name"]}"
      subnet_cidr_0 = "${var.ns_net_prov["p2p_vmx01_rtr01_subnet_cidr"]}"
    }

    ew_net_prov_count = "${var.ew_net_prov_count}"
    ew_net_prov = {}
}

module "vmx01" {
    source = "./modules/vmx"

    #Openstack connectivity
    osp_user_name = "${var.osp_user_name}"
    osp_user_domain_name = "${var.osp_user_domain_name}"
    osp_project_name = "${var.osp_project_name}"
    osp_project_domain_name = "${var.osp_project_domain_name}"
    osp_user_pass = "${var.osp_user_pass}"
    osp_auth_url = "${var.osp_auth_url}"
    osp_region = "${var.osp_region}"

    # Visibility of the created resources
    resource_visibility = "${var.resource_visibility}"

    #Routing/switching
    #vMX
    vmx_default_pass_root = "${var.default_pass}"
    vmx_default_pass_admin = "${var.default_pass}"
    vmx_timezone = "${var.time_zone}"
    vmx_dns_srv01= "${var.dns_srv01}"
    vmx_dns_srv02 = "${var.dns_srv02}"
    vmx_ntp_srv00 = "${var.ntp_srv00}"
    vmx_ntp_srv01 = "${var.ntp_srv01}"

    vmx_name = "vmx01"
    vmx_vcp_name = "vmx01-vcp"
    vmx_vfp_name = "vmx01-vfp"
    vmx_vcp_instance_name = "vmx01-vcp-ctrl_plane"
    vmx_vcp_image_name = "${var.vm_imgs["vmx_vcp_image_name"]}"
    vmx_vcp_image_path = "${var.vm_imgs["vmx_vcp_image_path"]}"
    vmx_vcp_flav_name = "${var.vm_imgs["vmx_vcp_flav_name"]}"
    vmx_vfp_instance_name = "vmx01-vfp-data_plane"
    vmx_vfp_image_name = "${var.vm_imgs["vmx_vfp_image_name"]}"
    vmx_vfp_image_path = "${var.vm_imgs["vmx_vfp_image_path"]}"
    vmx_vfp_flav_name = "${var.vm_imgs["vmx_vfp_flav_name"]}"

    #Network plan
    #mgmt networking
    mgmt_net_name = "${var.mgmt_net_name}"
    mgmt_net_type = "${var.mgmt_net_type}"
    mgmt_net_physical_net = "${var.mgmt_net_physical_net}"
    mgmt_net_segmentation_id = "${var.mgmt_net_segmentation_id}"
    mgmt_subnet_name = "${var.mgmt_subnet_name}"
    mgmt_subnet_cidr = "${var.mgmt_subnet_cidr}"
    mgmt_subnet_pool01_start = "${var.mgmt_subnet_pool01_start}"
    mgmt_subnet_pool01_end = "${var.mgmt_subnet_pool01_end}"
    mgmt_subnet_gw = "${var.mgmt_subnet_gw}"

    mtu_mgmt = "${var.mtu_mgmt}"
    vmx_mtu_base = "${var.mtu_ew}"

    #subnet1 = "${module.network.subnet1}"

    #vMX mgmt ports
    vmx_vcp_mgmt_port_name = "vmx01-vcp-mgmt-port"
    vmx_vcp_mgmt_port_ip = "192.168.100.200"
    vmx_vfp_mgmt_port_name = "vmx01-vfp-mgmt-port"
    vmx_vfp_mgmt_port_ip = "192.168.100.201"

    #vMX networking

    #vMX RE (vcp) <-> PFE (vfp) network
    vmx_base_net_name = "INT-VMX01-BASE-NET"
    vmx_base_subnet_name = "INT-VMX01-BASE-SUBNET"
    vmx_base_subnet_cidr = "128.0.0.0/24"
    vmx_base_subnet_gw = "128.0.0.3"
    vmx_vcp_base_port_name = "int-vmx01-vcp-base-port"
    vmx_vcp_base_port_ip01 = "128.0.0.1"
    vmx_vcp_base_port_ip02 = "128.0.0.4"
    vmx_vfp_base_port_name = "int-vmx01-vfp-base-port"
    vmx_vfp_base_port_ip01 = "128.0.0.16"

    #vMX NS networking (tenant networks)
    vmx_ns_net_ten_count = "${var.vmx_ns_net_ten_count}"
    vmx_ns_net_ten = {

      net_name_0 = "${var.ns_net_ten["p2p_vmx01_vsrx01_net_name"]}"
      subnet_name_0 = "${var.ns_net_ten["p2p_vmx01_vsrx01_subnet_name"]}"
      subnet_cidr_0 = "${var.ns_net_ten["p2p_vmx01_vsrx01_subnet_cidr"]}"
      port_name_0 = "vmx01-vsrx01-port"
      port_ip_0 = "10.0.0.1"

    }

    vmx_ns_net_prov_count = "${var.vmx_ns_net_prov_count}"
    vmx_ns_net_prov = {

      net_name_0 = "${var.ns_net_prov["p2p_vmx01_rtr01_net_name"]}"
      net_type_0 = "${var.ns_net_prov["p2p_vmx01_rtr01_net_type"]}"
      net_physical_net_0 = "${var.ns_net_prov["p2p_vmx01_rtr01_net_physical_net"]}"
      net_segmentation_id_0 = "${var.ns_net_prov["p2p_vmx01_rtr01_net_segmentation_id"]}"
      subnet_name_0 = "${var.ns_net_prov["p2p_vmx01_rtr01_subnet_name"]}"
      subnet_cidr_0 = "${var.ns_net_prov["p2p_vmx01_rtr01_subnet_cidr"]}"
      port_name_0 = "vmx01-rtr01-port"
      port_ip_0 = "10.128.0.1"
  }
}

module "vsrx01" {
  source = "./modules/vsrx"

  #Openstack connectivity
  osp_user_name = "${var.osp_user_name}"
  osp_user_domain_name = "${var.osp_user_domain_name}"
  osp_project_name = "${var.osp_project_name}"
  osp_project_domain_name = "${var.osp_project_domain_name}"
  osp_user_pass = "${var.osp_user_pass}"
  osp_auth_url = "${var.osp_auth_url}"
  osp_region = "${var.osp_region}"

  # Visibility of the created resources
  resource_visibility = "${var.resource_visibility}"

  vsrx_default_pass_root = "${var.default_pass}"
  vsrx_default_pass_admin = "${var.default_pass}"
  vsrx_timezone = "${var.time_zone}"
  vsrx_dns_srv01 = "${var.dns_srv01}"
  vsrx_dns_srv02 = "${var.dns_srv02}"
  vsrx_ntp_srv00 = "${var.ntp_srv00}"
  vsrx_ntp_srv01 = "${var.ntp_srv01}"

  vsrx_name = "vsrx01"
  vsrx_image_name = "${var.vm_imgs["vsrx_image_name"]}"
  vsrx_image_path = "${var.vm_imgs["vsrx_image_path"]}"
  vsrx_flav_name = "${var.vm_imgs["vsrx_flav_name"]}"
  vsrx_instance_name = "vsrx01"

  #Network plan
  #mgmt networking
  mgmt_net_name = "${var.mgmt_net_name}"
  mgmt_net_type = "${var.mgmt_net_type}"
  mgmt_net_physical_net = "${var.mgmt_net_physical_net}"
  mgmt_net_segmentation_id = "${var.mgmt_net_segmentation_id}"
  mgmt_subnet_name = "${var.mgmt_subnet_name}"
  mgmt_subnet_cidr = "${var.mgmt_subnet_cidr}"
  mgmt_subnet_pool01_start = "${var.mgmt_subnet_pool01_start}"
  mgmt_subnet_pool01_end = "${var.mgmt_subnet_pool01_end}"
  mgmt_subnet_gw = "${var.mgmt_subnet_gw}"

  mtu_mgmt = "${var.mtu_mgmt}"

  #vSRX mgmt ports
  vsrx_mgmt_port_name = "vsrx01-mgmt-port"
  vsrx_mgmt_port_ip = "192.168.100.204"

  #vSRX NS networking
  vsrx_ns_net_ten_count = "${var.vsrx_ns_net_ten_count}"

  vsrx_ns_net_ten = {

    net_name_0 = "${var.ns_net_ten["p2p_vmx01_vsrx01_net_name"]}"
    subnet_name_0 = "${var.ns_net_ten["p2p_vmx01_vsrx01_subnet_name"]}"
    subnet_cidr_0 = "${var.ns_net_ten["p2p_vmx01_vsrx01_subnet_cidr"]}"
    port_name_0 = "corpo-vsrx01-vfp-p2p-vmx01-vsrx01-port"
    port_ip_0 = "10.0.0.2"

  }

  vsrx_ns_net_prov_count = "${var.vsrx_ns_net_prov_count}"
  vsrx_ns_net_prov = {}
}