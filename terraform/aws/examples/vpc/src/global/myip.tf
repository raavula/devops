variable myip_cidrs { default = "24.4.221.161/32" }
output myip_cidrs    { value = "${var.myip_cidrs}" }
