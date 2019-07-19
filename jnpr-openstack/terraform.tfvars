#Common parameters

#Openstack connectivity
osp_user_name = "admin"
osp_project_name = "LAB"
osp_user_pass = "P@$$w0rd321!"
osp_auth_url = "http://192.168.0.1:5000/v3"
osp_region = "regionOne"
osp_project_domain_name = "default"
osp_user_domain_name = "Default"

# Visibility of the created resources
resource_visibility = "public"

default_pass = "P@$$w0rd321!"
time_zone = "Europe/Warsaw"
dns_srv01 = "8.8.8.8"
dns_srv02 = "8.8.4.4"
ntp_srv00 = "213.199.225.40"
ntp_srv01 = "195.46.37.22"

# Global MTU setting
mtu_mgmt = 1500
mtu_ns = 8950
mtu_ew = 8950

# existing MGMT network
mgmt_net_name = "MGMT-NET"
mgmt_net_type = "vlan"
mgmt_net_physical_net = "phyMGMT"
mgmt_net_segmentation_id = "100"
mgmt_subnet_name = "MGMT-SUBNET"
mgmt_subnet_cidr = "192.168.100.0/24"
mgmt_subnet_pool01_start = "192.168.100.128"
mgmt_subnet_pool01_end = "192.168.100.254"
mgmt_subnet_gw = "192.168.100.1"
mgmt_netmask = "24"

vsrx_ns_net_ten_count = "1"
vmx_ns_net_ten_count = "1"

ns_net_ten_count = "1"
ns_net_ten = {

    p2p_vmx01_vsrx01_net_name = "P2P-VMX01-VSRX01-NET"
    p2p_vmx01_vsrx01_subnet_name = "P2P-VMX01-VSRX01-SUBNET"
    p2p_vmx01_vsrx01_subnet_cidr = "10.0.0.0/30"
}

ew_net_ten_count = "0"
ew_net_ten = {}

vsrx_ns_net_prov_count = "0"
vmx_ns_net_prov_count = "1"

ns_net_prov_count = "1"
ns_net_prov = {

    p2p_vmx01_rtr01_net_name = "P2P-VMX01-RTR01-NET"
    p2p_vmx01_rtr01_net_type = "vlan"
    p2p_vmx01_rtr01_net_physical_net = "phyPROV"
    p2p_vmx01_rtr01_net_segmentation_id = "1000"
    p2p_vmx01_rtr01_subnet_name = "P2P-VMX01-RTR01-SUBNET"
    p2p_vmx01_rtr01_subnet_cidr = "10.128.0.0/30"

}

ew_net_prov_count = "0"
ew_net_prov = {}

vm_img_count = 3
vm_imgs = {

    vmx_vcp_image_name = "vmx-vcp-18.4R1.8"
    vmx_vcp_image_path = "/sw/vmx/images/junos-vmx-x86-64-18.4R1.8.qcow2"
    vmx_vcp_flav_name = "vmx-vcp-flav"

    vmx_vfp_image_name = "vmx-vfp-18.4R1.8"
    vmx_vfp_image_path = "/sw/vmx/images/vFPC-20181130.img"
    vmx_vfp_flav_name = "vmx-vfp-flav"

    vsrx_image_name = "vsrx3-18.4R1-S2.4"
    vsrx_image_path = "/sw/vsrx/junos-vsrx3-x86-64-18.4R1-S2.4.qcow2"
    vsrx_flav_name = "vsrx-flav"
}
