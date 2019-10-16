resource "openstack_compute_instance_v2" "web01" {
  name        = "lb-2w-web01"
  image_name  = var.image
  flavor_name = var.flavor
  key_pair    = openstack_compute_keypair_v2.full.name
  user_data   = file("${path.module}/user-data/${var.image}.sh")
  network {
    port = openstack_networking_port_v2.web01.id
  }

  timeouts {
    create = var.timeout
    delete = var.timeout
  }
}

resource "openstack_compute_instance_v2" "web02" {
  name        = "lb-2w-web02"
  image_name  = var.image
  flavor_name = var.flavor
  key_pair    = openstack_compute_keypair_v2.full.name
  user_data   = file("${path.module}/user-data/${var.image}.sh")
  network {
    port = openstack_networking_port_v2.web02.id
  }

  timeouts {
    create = var.timeout
    delete = var.timeout
  }
}

resource "openstack_compute_keypair_v2" "full" {
  name  = "lb-2w-full"
}

resource "openstack_networking_port_v2" "web01" {
  name            = "principal"
  network_id      = openstack_networking_network_v2.private.id
  admin_state_up  = true
  security_group_ids = [
    openstack_compute_secgroup_v2.ssh.id,
    openstack_compute_secgroup_v2.http.id,
  ]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.private.id
  }
}

resource "openstack_networking_port_v2" "web02" {
  name            = "principal"
  network_id      = openstack_networking_network_v2.private.id
  admin_state_up  = true
  security_group_ids = [
    openstack_compute_secgroup_v2.ssh.id,
    openstack_compute_secgroup_v2.http.id,
  ]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.private.id
  }
}

resource "openstack_compute_secgroup_v2" "http" {
  name        = "http"
  description = "http security group"
  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "192.168.0.0/24"
  }
}

resource "openstack_compute_secgroup_v2" "ssh" {
  name        = "ssh"
  description = "ssh security group"
  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_networking_floatingip_v2" "web01" {
  pool = "public"
}

resource "openstack_networking_floatingip_v2" "web02" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "web01" {
  floating_ip = openstack_networking_floatingip_v2.web01.address
  instance_id = openstack_compute_instance_v2.web01.id
}

resource "openstack_compute_floatingip_associate_v2" "web02" {
  floating_ip = openstack_networking_floatingip_v2.web02.address
  instance_id = openstack_compute_instance_v2.web02.id
}
