resource "openstack_lb_loadbalancer_v2" "lb" {
  name            = "lb-2w"
  vip_subnet_id   = openstack_networking_subnet_v2.private.id
  depends_on      = [ openstack_compute_instance_v2.web ]

  timeouts {
    create = var.timeout
    delete = var.timeout
  }
}

resource "openstack_networking_floatingip_v2" "lb" {
  pool    = "public"
  port_id = "${openstack_lb_loadbalancer_v2.lb.vip_port_id}"
  depends_on      = [ openstack_lb_loadbalancer_v2.lb ]
}

resource "openstack_lb_listener_v2" "http" {
  name            = "http"
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.lb.id
  depends_on      = [ openstack_lb_loadbalancer_v2.lb ]
}

resource "openstack_lb_pool_v2" "web" {
  name        = "web"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.http.id
  depends_on  = [ openstack_lb_listener_v2.http ]
}

resource "openstack_lb_member_v2" "web" {
  count = length(var.instances)

  address       = openstack_compute_instance_v2.web[count.index].access_ip_v4
  protocol_port = 80
  pool_id       = openstack_lb_pool_v2.web.id
  subnet_id     = openstack_networking_subnet_v2.private.id
  depends_on    = [ openstack_lb_pool_v2.web ]
}

resource "openstack_lb_monitor_v2" "web" {
  name            = "web"
  pool_id         = openstack_lb_pool_v2.web.id
  type            = "HTTP"
  url_path        = "/"
  expected_codes  = "200"
  delay           = 2
  timeout         = 2
  max_retries     = 2
  depends_on      = [ openstack_lb_member_v2.web ]
}
