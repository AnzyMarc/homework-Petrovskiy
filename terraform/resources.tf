# Сеть
resource "yandex_vpc_network" "network-1" {
  name = "network1"
}


data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

# Подсеть
resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Виртуальная машина для RabbitMQ
resource "yandex_compute_instance" "vm-rabbit" {
  name = "rabbit-host"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id 
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true # Внешний IP обязателен для Ansible
  }

 metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}

# Чтобы не искать IP в консоли, выведем его в терминал
output "external_ip_rabbit" {
  value = yandex_compute_instance.vm-rabbit.network_interface.0.nat_ip_address
}


