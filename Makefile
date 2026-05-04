# Переменные
TF_DIR = terraform
INVENTORY = $(CURDIR)/ansible/hosts.ini
PLAYBOOK = deploy_mysql.yml

.PHONY: all up deploy down ping

# Поднять всё одной командой
all: up deploy

# Создаем инфраструктуру и АВТОМАТИЧЕСКИ обновляем hosts.ini
up:
	@echo "--- Запуск Terraform ---"
	cd $(TF_DIR) && terraform init && terraform apply -auto-approve
	@echo "--- Формирование hosts.ini ---"
	@# $(dir $(INVENTORY)) 
	@mkdir -p $(dir $(INVENTORY)) 
	@echo "[mysql_server]" > $(INVENTORY)
	@cd $(TF_DIR) && terraform output -raw external_ip_mysql | awk '{print $$1 " ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_ed25519"}' >> "$(INVENTORY)"
	@echo "--- IP адрес записан в $(INVENTORY) ---"



# Запуск деплоя
deploy:
	@echo "--- Извлекаем внутренний IP для настройки ---"
	@$(eval INT_IP_MYSQL=$(shell cd "$(TF_DIR)" && terraform output -raw internal_ip_mysql))
	@echo "--- Запуск Ansible для MySQL ---"
	@# Просто пропишем папку словом, если переменная капризничает
	@cd "ansible" && \
	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts.ini "$(PLAYBOOK)" \
		--extra-vars "mysql_internal_ip=$(INT_IP_MYSQL)"
# Удаление
down:
	@echo "--- Удаление инфраструктуры в облаке ---"
	cd $(TF_DIR) && terraform destroy -auto-approve
	@echo "--- Очистка файла инвентаризации ---"
	@echo "[rmq_servers]" > $(INVENTORY)

# Проверка связи
ping:
	cd $(ANSIBLE_DIR) && ansible rmq_servers -i hosts.ini -m ping