variable osp_user_name {}
variable osp_project_name {}
variable osp_user_pass {}
variable osp_auth_url {}
variable osp_region {}
variable osp_project_domain_name {}
variable osp_user_domain_name {}
variable default_pass {}
variable time_zone {}
variable ntp_srv00 {}
variable ntp_srv01 {}
variable dns_srv01 {}
variable dns_srv02 {}

variable mtu_mgmt {}
variable mtu_ns {}
variable mtu_ew {}

variable resource_visibility {}

variable mgmt_net_name {}
variable mgmt_net_type {} 
variable mgmt_net_physical_net {}
variable mgmt_net_segmentation_id {}
variable mgmt_subnet_name {}

variable mgmt_subnet_cidr {}
variable mgmt_subnet_pool01_start {}
variable mgmt_subnet_pool01_end {}
variable mgmt_subnet_gw {}
variable mgmt_netmask {}

variable ns_net_ten_count {}
variable ns_net_ten {
    type = "map"
}
variable ew_net_ten_count {}
variable ew_net_ten {
    type = "map"
}
variable ns_net_prov_count {}
variable ns_net_prov {
    type = "map"
}
variable ew_net_prov_count {}
variable ew_net_prov {
    type = "map"
}

variable vm_img_count {}
variable vm_imgs {
    type = "map"
}

variable vmx_ns_net_ten_count {}
variable vmx_ns_net_prov_count {}
variable vsrx_ns_net_ten_count {}
variable vsrx_ns_net_prov_count {}