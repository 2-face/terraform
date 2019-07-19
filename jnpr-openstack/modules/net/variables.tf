variable osp_user_name {}
variable osp_project_name {}
variable osp_user_pass {}
variable osp_auth_url {}
variable osp_region {}
variable osp_project_domain_name {}
variable osp_user_domain_name {}

# Visibility of the created resources
variable resource_visibility {}

#Networks
variable mtu_ns {}
variable mtu_ew {}
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