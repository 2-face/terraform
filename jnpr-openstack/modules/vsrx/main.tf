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
data "openstack_images_image_v2" "VSRX_IMG" {
  name   = "${var.vsrx_image_name}"
  most_recent = true
}

data "template_file" "VSRX_BASELINE_CFG" {
  template = "${file("${path.root}/bootstrap_cfg/vsrx_baseline.conf")}"
  vars = {
    hostname = "${var.vsrx_name}"
    mgmt_ip = "${format("%s/%s", "${var.vsrx_mgmt_port_ip}", "${element("${split("/", "${var.mgmt_subnet_cidr}")}", 1)}")}"
    mgmt_gw = "${var.mgmt_subnet_gw}"
    pub_key = "${file("${path.root}/bootstrap_cfg/id_ed25519.pub")}"
  }
}

data "openstack_compute_flavor_v2" "VSRX_FLAV" {
  name   = "${var.vsrx_flav_name}"
}

resource "openstack_compute_instance_v2" "VSRX_VM" {
  name            = "${var.vsrx_instance_name}"
  image_id        = "${data.openstack_images_image_v2.VSRX_IMG.id}"
  flavor_id       = "${data.openstack_compute_flavor_v2.VSRX_FLAV.id}"
  config_drive   = "true"
  security_groups = ["default"]

  #MGMT port
  network = {
    port = "${openstack_networking_port_v2.VSRX_MGMT_PORT.id}"
  }
 
  #TENANT ports
  network = {
    port = "${openstack_networking_port_v2.VSRX_NS_PORT_TEN.0.id}"
  }

  network = {
    port = "${openstack_networking_port_v2.VSRX_NS_PORT_TEN.1.id}"
  }

  network = {
    port = "${openstack_networking_port_v2.VSRX_NS_PORT_TEN.2.id}"
  }

  network = {
    port = "${openstack_networking_port_v2.VSRX_NS_PORT_TEN.3.id}"
  }

  network = {
    port = "${openstack_networking_port_v2.VSRX_NS_PORT_TEN.4.id}"
  }

    network = {
    port = "${openstack_networking_port_v2.VSRX_NS_PORT_TEN.5.id}"
  }

  network = {
    port = "${openstack_networking_port_v2.VSRX_NS_PORT_TEN.6.id}"
  }

  network = {
    port = "${openstack_networking_port_v2.VSRX_NS_PORT_TEN.7.id}"
  }

  #PROVIDER ports
  network = {
    port = "${openstack_networking_port_v2.VSRX_NS_PORT_PROV.0.id}"
  }


  user_data = "${data.template_file.VSRX_BASELINE_CFG.rendered}"

  provisioner "file" {
    source      = "${path.root}/bootstrap_cfg/vsrx_login-script.slax"
    destination = "/var/db/scripts/op/login-script.slax"

    connection {
      type     = "ssh"
      timeout  = "10m"
      user     = "root"
      private_key = "${file("${path.root}/bootstrap_cfg/id_ed25519")}"
    }
  }
  
  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vsrx_mgmt_port_ip} '/usr/sbin/cli -c \"configure private; set system scripts op file login-script.slax; commit\"'"
  }

  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vsrx_mgmt_port_ip} '/usr/sbin/cli -c \"configure private; set groups global system login user admin authentication plain-text-password-value ${var.vsrx_default_pass_admin}; commit\"'"
  }

  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vsrx_mgmt_port_ip} '/usr/sbin/cli -c \"configur private; set groups global system login class super-user-with-login-script login-script login-script.slax; commit\"'"
  }

  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vsrx_mgmt_port_ip} '/usr/sbin/cli -c \"configure private; set groups global system root-authentication plain-text-password-value ${var.vsrx_default_pass_root}; commit\"'"
  }

  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vsrx_mgmt_port_ip} '/usr/sbin/cli -c \"configure private; set groups global system name-server ${var.vsrx_dns_srv01} routing-instance mgmt_junos; commit\"'"
  }

  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vsrx_mgmt_port_ip} '/usr/sbin/cli -c \"configure private; set groups global system name-server ${var.vsrx_dns_srv02} routing-instance mgmt_junos; commit\"'"
  }

  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vsrx_mgmt_port_ip} '/usr/sbin/cli -c \"configure private; set groups global system ntp server ${var.vsrx_ntp_srv00} routing-instance mgmt_junos; commit\"'"
  }

  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vsrx_mgmt_port_ip} '/usr/sbin/cli -c \"configure private; set groups global system ntp server ${var.vsrx_ntp_srv01} routing-instance mgmt_junos; commit\"'"
  }

  provisioner "local-exec" {
      command = "ssh -i '${path.root}/bootstrap_cfg/id_ed25519' -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${var.vsrx_mgmt_port_ip} '/usr/sbin/cli -c \"configure private; set groups global system time-zone ${var.vsrx_timezone}; commit\"'"
  }

  depends_on = ["openstack_networking_port_v2.VSRX_MGMT_PORT", "openstack_networking_port_v2.VSRX_NS_PORT_TEN", "openstack_networking_port_v2.VSRX_NS_PORT_PROV"]
}

#BUG - attachments cannot be deleted with "terraform destroy"
/*resource "openstack_compute_interface_attach_v2" "VMX_VSRX_NS_TEN_ATTACHMENTS" {
  count       = "${var.vsrx_ns_net_ten_count}"
  instance_id = "${openstack_compute_instance_v2.VSRX_VM.id}"
  port_id     = "${openstack_networking_port_v2.VSRX_NS_PORT_TEN.*.id[count.index]}"
  
  depends_on = ["openstack_compute_instance_v2.VSRX_VM"]
}

resource "openstack_compute_interface_attach_v2" "VMX_VSRX_NS_PROV_ATTACHMENTS" {
  count       = "${var.vsrx_ns_net_prov_count}"
  instance_id = "${openstack_compute_instance_v2.VSRX_VM.id}"
  port_id     = "${openstack_networking_port_v2.VSRX_NS_PORT_PROV.*.id[count.index]}"
  
  depends_on = ["openstack_compute_instance_v2.VSRX_VM"]
}*/