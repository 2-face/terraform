provider "openstack" {
    user_name = "${var.osp_user_name}"
    user_domain_name = "${var.osp_user_domain_name}"
    tenant_name = "${var.osp_project_name}"
    project_domain_name = "${var.osp_project_domain_name}"
    password = "${var.osp_user_pass}"
    auth_url = "${var.osp_auth_url}"
    region = "${var.osp_region}"
}

#vSRX
#Images
resource "openstack_images_image_v2" "VSRX_IMG" {
  name   = "${var.vsrx_image_name}"
  local_file_path = "${var.vsrx_image_path}"
  container_format = "bare"
  disk_format = "qcow2"
  visibility = "${var.resource_visibility}"

  properties = {
    hw_cdrom_bus = "ide"
    hw_disk_bus = "ide"
    hw_vif_model = "virtio"
  }
}
#Flavors
resource "openstack_compute_flavor_v2" "VSRX_FLAV" {
  name  = "${var.vsrx_flav_name}"
  ram   = "4096"
  vcpus = "2"
  disk  = "20"
  is_public = "${var.resource_visibility == "public" ? "true" : "false"}"

}

#vMX
#Images
resource "openstack_images_image_v2" "VMX_VCP_IMG" {
  name   = "${var.vmx_vcp_image_name}"
  local_file_path = "${var.vmx_vcp_image_path}"
  container_format = "bare"
  disk_format = "qcow2"
  visibility = "${var.resource_visibility}"

  properties = {
    hw_cdrom_bus = "ide"
    hw_disk_bus = "ide"
    hw_vif_model = "virtio"
  }
}
resource "openstack_images_image_v2" "VMX_VFP_IMG" {
  name   = "${var.vmx_vfp_image_name}"
  local_file_path = "${var.vmx_vfp_image_path}"
  container_format = "bare"
  disk_format = "qcow2"
  visibility = "${var.resource_visibility}"

  properties = {
    hw_cdrom_bus = "ide"
    hw_disk_bus = "ide"
    hw_vif_model = "virtio"
  }
}
#Flavors
resource "openstack_compute_flavor_v2" "VMX_VCP_FLAV" {
  name  = "${var.vmx_vcp_flav_name}"
  ram   = "1024"
  vcpus = "1"
  disk  = "40"
  is_public = "${var.resource_visibility == "public" ? "true" : "false"}"
}

resource "openstack_compute_flavor_v2" "VMX_VFP_FLAV" {
  name  = "${var.vmx_vfp_flav_name}"
  ram   = "4096"
  vcpus = "3"
  disk  = "4"
  is_public = "${var.resource_visibility == "public" ? "true" : "false"}"
}