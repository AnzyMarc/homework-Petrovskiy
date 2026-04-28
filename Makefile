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
	@echo "--- Запуск Terraform (создаем 2 ноды) ---"
	cd $(TF_DIR) && terraform init && terraform apply -auto-approve
	@echo "--- Формирование hosts.ini ---"
	@echo "[rmq_servers]" > $(INVENTORY)
	@# Вызываем terraform output напрямую в цикле
	@for ip in $$(cd $(TF_DIR) && terraform output -json external_ips_rabbit | jq -r '.[]'); do \
		echo "$$ip ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_ed25519" >> $(INVENTORY); \
	done
	@echo "--- IP адреса записаны в $(INVENTORY) ---"
	@cd $(TF_DIR) && terraform output

# Запуск деплоя
deploy:
	@echo "--- Извлекаем внутренние IP для конфигурации /etc/hosts ---"
	$(eval INT_IP0=$(shell cd $(TF_DIR) && terraform output -json internal_ips_rabbit | jq -r '.[0]'))
	$(eval INT_IP1=$(shell cd $(TF_DIR) && terraform output -json internal_ips_rabbit | jq -r '.[1]'))
	@echo "--- Запуск Ansible ---"
	cd $(ANSIBLE_DIR) && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts.ini $(PLAYBOOK) \
		--extra-vars "rmq0_ip=$(INT_IP0) rmq1_ip=$(INT_IP1)"
# Удаление
down:
	@echo "--- Удаление инфраструктуры в облаке ---"
	cd $(TF_DIR) && terraform destroy -auto-approve
	@echo "--- Очистка файла инвентаризации ---"
	@echo "[rmq_servers]" > $(INVENTORY)

# Проверка связи
ping:
	cd $(ANSIBLE_DIR) && ansible rmq_servers -i hosts.ini -m ping