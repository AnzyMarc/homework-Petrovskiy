#!/usr/bin/env python
# coding=utf-8
import pika
import sys

# 1. Настройка параметров подключения
# Используем имя сервиса 'rmq01' вместо 'localhost', так как внутри сети Docker это имя резолвится в IP
# Добавляем авторизацию, которую мы указали в docker-compose
credentials = pika.PlainCredentials('andrei', 'password')
parameters = pika.ConnectionParameters(host='rmq01', credentials=credentials)

try:
    connection = pika.BlockingConnection(parameters)
    channel = connection.channel()

    # 2. Объявляем очередь (на случай, если потребитель запустился раньше отправителя)
    channel.queue_declare(queue='hello')

    def callback(ch, method, properties, body):
        # Декодируем body из байтов в строку для чистого вывода
        print(f" [x] Received {body.decode('utf-8')}")

    # 3. Настройка подписки
    # В новых версиях pika аргументы передаются именованно
    channel.basic_consume(queue='hello', 
                          on_message_callback=callback, 
                          auto_ack=True)

    print(' [*] Waiting for messages. To exit press CTRL+C')
    channel.start_consuming()

except pika.exceptions.AMQPConnectionError:
    print(" [!] Не удалось подключиться к RabbitMQ. Проверь, запущен ли контейнер rmq01.")
except KeyboardInterrupt:
    print('Interrupted')
    sys.exit(0)