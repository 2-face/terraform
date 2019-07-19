variable osp_user_name {}
variable osp_project_name {}
variable osp_user_pass {}
variable osp_auth_url {}
variable osp_region {}
variable osp_project_domain_name {}
variable osp_user_domain_name {}

# Visibility of the created resources
variable resource_visibility {}

variable vsrx_default_pass_root {}
variable vsrx_default_pass_admin {}

variable vsrx_timezone {}
variable vsrx_dns_srv01 {}
variable vsrx_dns_srv02 {}
variable vsrx_ntp_srv00 {}
variable vsrx_ntp_srv01 {}

#MTU settings
variable mtu_mgmt {}

#Firewalls

#vSRX
variable vsrx_name {}
variable vsrx_instance_name {}
variable vsrx_image_name {}
variable vsrx_image_path {}
variable vsrx_flav_name {}

#vSRX networking

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

variable vsrx_mgmt_port_name {}
variable vsrx_mgmt_port_ip {}
variable vsrx_ns_net_ten_count {}
variable vsrx_ns_net_ten {
    type = "map"
}
variable vsrx_ns_net_prov_count {}
variable vsrx_ns_net_prov {
    type = "map"
}