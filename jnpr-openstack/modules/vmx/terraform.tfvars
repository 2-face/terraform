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
#Routing/switching/firewalls
#vMX
vmx_default_pass_root = "P@$$w0rd321!"
vmx_default_pass_admin = "P@$$w0rd321!"

vmx_name = "vmx01"
vmx_vcp_name = "vmx-vcp01"
vmx_vfp_name = "vmx-vfp01"
vmx_vcp_image_name = "vmx-vcp-18.4R1.8"
vmx_vcp_image_path = "/vmx/images/junos-vmx-x86-64-18.4R1.8.qcow2"
vmx_vcp_flav_name = "vmx-vcp-flav"
vmx_vcp_instance_name = "vmx-vcp-ctrl_plane"
vmx_vfp_image_name = "vmx-vfp-18.4R1.8"
vmx_vfp_image_path = "/vmx/images/vFPC-20181130.img"
vmx_vfp_flav_name = "vmx-vfp-flav"
vmx_vfp_instance_name = "vmx-vfp-data_plane"
#Network plan
#mgmt networking
mgmt_net_name = "AN-MGMT"
mgmt_net_type = "vlan"
mgmt_net_physical_net = "phyOAM"
mgmt_net_segmentation_id = "4001"
mgmt_subnet_name = "AN-MGMT-MCC"
mgmt_subnet_cidr = "10.134.1.0/24"
mgmt_subnet_pool01_start = "10.134.1.2"
mgmt_subnet_pool01_end = "10.134.1.254"
mgmt_subnet_gw = "10.134.1.1"
#vMX mgmt ports
vmx_vcp_mgmt_port_name = "vmx-vcp-mgmt-port"
vmx_vcp_mgmt_port_ip = "10.134.1.130"
vmx_vfp_mgmt_port_name = "vmx-vfp-mgmt-port"
vmx_vfp_mgmt_port_ip = "10.134.1.131"
#vMX networking
#vMX RE (vcp) <-> PFE (vfp) network
vmx_base_net_name = "AN-VMX-BASE-NET"
vmx_base_subnet_name = "AN-VMX-BASE-SUBNET"
vmx_base_subnet_cidr = "128.0.0.0/24"
#vmx_base_subnet_pool01_start = "10.134.1.2"
#vmx_base_subnet_pool01_end = "10.134.1.254"
vmx_base_subnet_gw = "128.0.0.3"
vmx_vcp_base_port_name = "vmx-vcp-base-port"
vmx_vcp_base_port_ip01 = "128.0.0.1"
vmx_vcp_base_port_ip02 = "128.0.0.4"
vmx_vfp_base_port_name = "vmx-vfp-base-port"
vmx_vfp_base_port_ip01 = "128.0.0.16"
#vMX NS networking
vmx_vfp_ns01_net_name = "AN-VMX-NS01-NET"
vmx_vfp_ns01_net_type = "vlan"
vmx_vfp_ns01_net_physical_net = "phyprov"
vmx_vfp_ns01_net_segmentation_id = "900"
vmx_vfp_ns01_subnet_name = "AN-VMX-NS01-SUBNET"
vmx_vfp_ns01_subnet_cidr = "${data.netbox_prefixes.prefixes.prefix}"
#vmx_vfp_ns01_subnet_cidr = "10.135.5.0/30"
vmx_vfp_ns01_subnet_gw = "10.135.5.1"
vmx_vfp_ns01_port_name = "vmx-vfp-ns01-port"
vmx_vfp_ns01_port_ip = "10.135.5.2"