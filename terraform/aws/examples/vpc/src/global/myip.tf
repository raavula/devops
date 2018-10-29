variable myip_cidrs { default = "128.107.241.0/24" }
output myip_cidrs    { value = "${var.myip_cidrs}" }
