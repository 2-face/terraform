variable osp_user_name {}
variable osp_project_name {}
variable osp_user_pass {}
variable osp_auth_url {}
variable osp_region {}
variable osp_project_domain_name {}
variable osp_user_domain_name {}

# Visibility of the created resources
variable resource_visibility {}

#Routing/switching

#vMX
variable vmx_name {}
variable vmx_vcp_name {}
variable vmx_vfp_name {}

variable vmx_default_pass_root {}
variable vmx_default_pass_admin {}

variable vmx_timezone {}
variable vmx_dns_srv01 {}
variable vmx_dns_srv02 {}
variable vmx_ntp_srv00 {}
variable vmx_ntp_srv01 {}

variable vmx_vcp_image_name {}
variable vmx_vcp_image_path {}
variable vmx_vcp_flav_name {}
variable vmx_vcp_instance_name {}
variable vmx_vfp_image_name {}
variable vmx_vfp_image_path {}
variable vmx_vfp_flav_name {}
variable vmx_vfp_instance_name {}

#Network plan
#mgmt networking
variable mgmt_net_name {}
variable mgmt_net_type {}
variable mgmt_net_physical_net {}
variable mgmt_net_segmentation_id {}
variable mgmt_subnet_name {}
variable mgmt_subnet_cidr {}
variable mgmt_subnet_pool01_start {}
variable mgmt_subnet_pool01_end {}
variable mgmt_subnet_gw {}

#MTU settings
variable mtu_mgmt {}
#VFP <-> VCP MTU
variable vmx_mtu_base {}

#vMX mgmt IP
variable vmx_vcp_mgmt_port_name {}
variable vmx_vcp_mgmt_port_ip {}
variable vmx_vfp_mgmt_port_name {}
variable vmx_vfp_mgmt_port_ip {}

#vMX networking
variable vmx_base_net_name {}
variable vmx_base_subnet_name {}
variable vmx_base_subnet_cidr {}
variable vmx_base_subnet_gw {}
variable vmx_vcp_base_port_name {}
variable vmx_vcp_base_port_ip01 {}
variable vmx_vcp_base_port_ip02 {}
variable vmx_vfp_base_port_name {}
variable vmx_vfp_base_port_ip01 {}
#vMX NS networking
variable vmx_ns_net_ten_count {}
variable vmx_ns_net_ten {
    type = "map"
}
variable vmx_ns_net_prov_count {}
variable vmx_ns_net_prov {
    type = "map"
}