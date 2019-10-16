data "openstack_networking_network_v2" "public" {
  name  = "public"
}

resource "openstack_networking_router_v2" "router" {
  name                = "lb-2w"
  external_network_id = data.openstack_networking_network_v2.public.id
}

resource "openstack_networking_network_v2" "private" {
  name = "lb-2w-private"
}

resource "openstack_networking_subnet_v2" "private" {
  name            = "lb-2w-private-subnet"
  network_id      = openstack_networking_network_v2.private.id
  cidr            = "192.168.0.0/24"
  dns_nameservers = [ "8.8.8.8", "8.8.8.4" ]
}

resource "openstack_networking_router_interface_v2" "private" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.private.id
}
