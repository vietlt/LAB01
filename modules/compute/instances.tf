resource "aws_instance" "linux_vm" {
  ami                     = var.ami_linux
  instance_type           = var.instance_type
  subnet_id               = "${var.linux_subnet_id_param.id}"
  vpc_security_group_ids  = [aws_security_group.allow_all.id]
  key_name                = "terraform-key-pair"

  tags = {
    Name = "linux"
  }
}


resource "aws_instance" "windows_vm" {
  ami                         = var.ami_windows
  instance_type               = var.instance_type
  subnet_id                   = "${var.windows_subnet_id_param.id}"
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  key_name                    = "terraform-key-pair"
  get_password_data           = "true"
  user_data = base64encode(file("userdata.ps1"))
  connection {
        host = coalesce(self.public_ip, self.private_ip)
        type = "winrm"
        port = 5986
        user = "administrator"
        password = "${rsadecrypt(aws_instance.windows_vm.password_data,file("terraform-key-pair.pem"))}"
        https = true
        insecure = true
        timeout = "13m"
  }

  

  tags = {
    Name = "windows"
  }
}

resource "null_resource" "configure" {
  triggers = {
    linux_vm_ids = "${aws_instance.linux_vm.id}"
    windows_vm_ids = "${aws_instance.windows_vm.id}"
  }

  provisioner "local-exec" {
    when    = create
    command = <<EOT
      sleep 75
      rm -f inventory.txt
      echo $ubuntu_ip > inventory.txt;
      echo $windows_ip > inventory.txt;
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ./main.yml -i inventory.txt
    EOT

    environment = {
      ubuntu_ip   = "Ubuntu ansible_host=${aws_instance.linux_vm.public_ip} ansible_connection=ssh ansible_user=ubuntu ansible_ssh_private_key_file=terraform-key-pair.pem"
      windows_ip  = "Windows ansible_host=${aws_instance.windows_vm.public_ip} ansible_connection=winrm ansible_user=administrator ansible_winrm_server_cert_validation=ignore ansible_password=${rsadecrypt(aws_instance.windows_vm.password_data,file("terraform-key-pair.pem"))}"
    }
  }  
}
