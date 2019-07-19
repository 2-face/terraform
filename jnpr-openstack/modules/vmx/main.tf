provider "openstack" {
    user_name = "${var.osp_user_name}"
    user_domain_name = "${var.osp_user_domain_name}"
    tenant_name = "${var.osp_project_name}"
    project_domain_name = "${var.osp_project_domain_name}"
    password = "${var.osp_user_pass}"
    auth_url = "${var.osp_auth_url}"
    region = "${var.osp_region}"
}

#Images
data "openstack_images_image_v2" "VMX_VCP_IMG" {
  name   = "${var.vmx_vcp_image_name}"
  most_recent = true
}

data "openstack_images_image_v2" "VMX_VFP_IMG" {
  name   = "${var.vmx_vfp_image_name}"
  most_recent = true
}

#Flavors
data "openstack_compute_flavor_v2" "VMX_VCP_FLAV" {
  name  = "${var.vmx_vcp_flav_name}"
}

data "openstack_compute_flavor_v2" "VMX_VFP_FLAV" {
  name  = "${var.vmx_vfp_flav_name}"
}

data "template_file" "VMX_BASELINE_CFG" {
  template = "${file("${path.root}/bootstrap_cfg/vmx_baseline.conf")}"
  vars = {
    pub_key = "${file("${path.root}/bootstrap_cfg/id_ed25519.pub")}"
  }
}

resource "openstack_compute_instance_v2" "VMX_VCP_VM" {
  name            = "${var.vmx_vcp_instance_name}"
  image_id        = "${data.openstack_images_image_v2.VMX_VCP_IMG.id}"
  flavor_id       = "${data.openstack_compute_flavor_v2.VMX_VCP_FLAV.id}"
  config_drive   = "true"
  security_groups = ["default"]

  metadata = {
    gateway = "${var.mgmt_subnet_gw}"
    hostname = "${var.vmx_vcp_name}"
    hw.pci.link.0x60.irq = "10"
    netmask = "24"
    re0_ip = "${var.vmx_vcp_mgmt_port_ip}"
    re1_ip = "${var.vmx_vcp_mgmt_port_ip}"
    vm_chassis_i2cid = "161"
    vm_chassisname = "${var.vmx_name}"
    vm_chassname = "${var.vmx_name}"
    vm_i2cid = "0xBAA"
    vm_instance = "0"
    vm_is_virtual = "1"
    vm_ore_present = "0"
    vm_retype = "RE-VMX"
    vmchtype = "mx240"
    vmtype = "0"
    console = "vidconsole"
  }

  network = {
    port = "${openstack_networking_port_v2.VMX_VCP_MGMT_PORT.id}"
  }

  network = {
    port = "${openstack_networking_port_v2.VMX_VCP_BASE_PORT.id}"
  }

  personality = {
    file    = "/var/db/cumulus/baseline_config.template"
    content = "${data.template_file.VMX_BASELINE_CFG.rendered}"
  }

  #Cannot be copied during VM deployment
  #personality = {
  #  file    = "/var/db/scripts/op/login-script.slax"
  #  content = "${file("bootstrap_cfg/login-script.slax")}"
  #}


  provisioner "file" {
    source      = "${path.root}/bootstrap_cfg/vmx_login-script.slax"
    destination = "/var/db/scripts/op/login-script.slax"

    connection {
      type     = "ssh"
      timeout  = "10m"
      user     = "root"
      private_key = "${file("${path.root}/bootstrap_cfg/id_ed25519")}"
    }
  }
  
  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vmx_vcp_mgmt_port_ip} '/usr/sbin/cli -c \"configure private; set system scripts op file login-script.slax; commit\"'"
  }

  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vmx_vcp_mgmt_port_ip} '/usr/sbin/cli -c \"configure private; set groups global system login user admin authentication plain-text-password-value ${var.vmx_default_pass_admin}; commit\"'"
  }

  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vmx_vcp_mgmt_port_ip} '/usr/sbin/cli -c \"configur private; set groups global system login class super-user-with-login-script login-script login-script.slax; commit\"'"
  }

  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vmx_vcp_mgmt_port_ip} '/usr/sbin/cli -c \"configure private; set groups global system root-authentication plain-text-password-value ${var.vmx_default_pass_root} commit\"'"
  }

  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vmx_vcp_mgmt_port_ip} '/usr/sbin/cli -c \"configure private; set groups global system name-server ${var.vmx_dns_srv01} routing-instance mgmt_junos; commit\"'"
  }

  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vmx_vcp_mgmt_port_ip} '/usr/sbin/cli -c \"configure private; set groups global system name-server ${var.vmx_dns_srv02} routing-instance mgmt_junos; commit\"'"
  }
  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vmx_vcp_mgmt_port_ip} '/usr/sbin/cli -c \"configure private; set groups global system ntp server ${var.vmx_ntp_srv00} routing-instance mgmt_junos; commit\"'"
  }

  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vmx_vcp_mgmt_port_ip} '/usr/sbin/cli -c \"configure private; set groups global system ntp server ${var.vmx_ntp_srv01} routing-instance mgmt_junos;commit\"'"
  }

  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vmx_vcp_mgmt_port_ip} '/usr/sbin/cli -c \"configure private; set groups global system time-zone ${var.vmx_timezone} commit\"'"
  }

  #BUG - doesn't work with Junos sice commands are wrapped with /tmp/terraform.sh script which when launched using ./tmp/terraform.sh throws authentication error
  #      if it was launched with /bin/sh /tmp/terraform.sh then it would work
  /*provisioner "remote-exec" {
    inline = [
      "/usr/sbin/cli -c \"configure private; set system scripts op file login-script.slax; commit\"",
      "/usr/sbin/cli -c \"configure private; set groups global system login user admin authentication plain-text-password-value P@$$w0rd321!; commit\"",
      "/usr/sbin/cli -c \"configure private; set groups global system login class super-user-with-login-script login-script login-script.slax; commit\"",
      "/usr/sbin/cli -c \"configure private; set groups global system root-authentication plain-text-password-value P@$$w0rd321!; commit\"",
    ]
    #BUG - similar as above - doesn't work as well
    #script = "bootstrap_cfg/vmx_bootstrap_script.sh"

    connection {
      type     = "ssh"
      timeout  = "10m"
      user     = "root"
      agent    = "false"
      private_key = "${file("bootstrap_cfg/id_ed25519")}"
    }
  }*/

  depends_on = ["openstack_networking_port_v2.VMX_VCP_MGMT_PORT", "openstack_networking_port_v2.VMX_VCP_BASE_PORT"]

}

resource "openstack_compute_instance_v2" "VMX_VFP_VM" {
  name            = "${var.vmx_vfp_instance_name}"
  image_id        = "${data.openstack_images_image_v2.VMX_VFP_IMG.id}"
  flavor_id       = "${data.openstack_compute_flavor_v2.VMX_VFP_FLAV.id}"
  config_drive    = "true"
  security_groups = ["default"]

  metadata = {
    boot_noveriexec = "yes"
    gateway = "${var.mgmt_subnet_gw}"
    hostname = "${var.vmx_vfp_name}"
    hw.pci.link.0x60.irq = "10"
    netmask = "24"
    re0_ip = "${var.vmx_vfp_mgmt_port_ip}"
    vm_chassis_i2cid = "161"
    vm_chassisname = "${var.vmx_name}"
    vm_chassname = "${var.vmx_name}"
    vm_i2cid = "0xBAA"
    //FIXME - there can be more than one VFP (FPC)
    vm_instance = "0"
    vm_is_virtual = "1"
    vm_ore_present = "0"
    vm_retype = "RE-VMX"
    vmchtype = "mx240"
    vmtype = "1"
  }
 
  #MGMT port
  network = {
    port = "${openstack_networking_port_v2.VMX_VFP_MGMT_PORT.id}"
  }
   
  #BASE port
  network = {
    port = "${openstack_networking_port_v2.VMX_VFP_BASE_PORT.id}"
  }

  #TENANT ports
  network = {
    port = "${openstack_networking_port_v2.VMX_VFP_NS_PORT_TEN.0.id}"
  }

  #PROVIDER ports
  network = {
    port = "${openstack_networking_port_v2.VMX_VFP_NS_PORT_PROV.0.id}"
  }

  depends_on = ["openstack_networking_port_v2.VMX_VFP_MGMT_PORT", "openstack_networking_port_v2.VMX_VFP_BASE_PORT", "openstack_networking_port_v2.VMX_VFP_NS_PORT_TEN", "openstack_networking_port_v2.VMX_VFP_NS_PORT_PROV"]
}

#BUG - attachments cannot be deleted with "terraform destroy"
/*resource "openstack_compute_interface_attach_v2" "VMX_VFP_VM_NS_TEN_ATTACHMENTS" {
  count       = "${var.vmx_ns_net_ten_count}"
  instance_id = "${openstack_compute_instance_v2.VMX_VFP_VM.id}"
  port_id     = "${openstack_networking_port_v2.VMX_VFP_NS_PORT_TEN.*.id[count.index]}"

  depends_on = ["openstack_compute_instance_v2.VMX_VFP_VM"]
}
resource "openstack_compute_interface_attach_v2" "VMX_VFP_VM_NS_PROV_ATTACHMENTS" {
  count       = "${var.vmx_ns_net_prov_count}"
  instance_id = "${openstack_compute_instance_v2.VMX_VFP_VM.id}"
  port_id     = "${openstack_networking_port_v2.VMX_VFP_NS_PORT_PROV.*.id[count.index]}"

  depends_on = ["openstack_compute_instance_v2.VMX_VFP_VM"]
}*/