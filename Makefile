# Переменные
TF_DIR = terraform
ANSIBLE_DIR = ansible
INVENTORY = $(ANSIBLE_DIR)/hosts.ini
PLAYBOOK = rabbit_deploy.yml

.PHONY: all up deploy down ping

# Поднять всё одной командой
all: up deploy

# Создаем инфраструктуру и АВТОМАТИЧЕСКИ обновляем hosts.ini
up:
	@echo "--- Запуск Terraform ---"
	cd $(TF_DIR) && terraform init && terraform apply -auto-approve
	@echo "--- Обновление IP в hosts.ini ---"
	$(eval NEW_IP=$(shell cd $(TF_DIR) && terraform output -raw external_ip_rabbit))
	@echo "[rmq_servers]\n$(NEW_IP) ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_ed25519" > $(INVENTORY)
	@echo "Новый IP: $(NEW_IP) записан в $(INVENTORY)"

# Запуск деплоя
deploy:
	@echo "--- Запуск Ansible ---"
	cd $(ANSIBLE_DIR) && ansible-playbook -i hosts.ini $(PLAYBOOK)

# Удаление
down:
	cd $(TF_DIR) && terraform destroy -auto-approve

# Проверка связи
ping:
	cd $(ANSIBLE_DIR) && ansible rmq_servers -i hosts.ini -m ping