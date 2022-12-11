module "network" {
    source = "./modules/network/"
}

module "compute" {
    source                  = "./modules/compute/"
    vpc_id_param            = module.network.lab_vpc_out
    linux_subnet_id_param   ="${module.network.linux_subnet_out}"
    windows_subnet_id_param = "${module.network.windows_subnet_out}"
}

output "lab_vpc_out" {
  value = module.network.lab_vpc_out
}

output "sg_allow_all_out" {
  value = module.compute.sg_allow_all_out
}

output "windows_subnet_out" {
  value = module.network.windows_subnet_out
}

output "linux_subnet_out" {
  value = module.network.linux_subnet_out
}