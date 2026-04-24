#!/usr/bin/env python
# coding=utf-8
import pika

# 1. Указываем данные для входа (те, что мы прописали в docker-compose)
credentials = pika.PlainCredentials('andrei', 'password')

# 2. Подключаемся к rmq01 (имя сервиса в сети Docker)
parameters = pika.ConnectionParameters(host='rmq01', credentials=credentials)
connection = pika.BlockingConnection(parameters)
channel = connection.channel()

# 3. Объявляем очередь (чтобы убедиться, что она существует)
channel.queue_declare(queue='hello')

# 4. Отправляем сообщение
channel.basic_publish(exchange='', 
                      routing_key='hello', 
                      body='Hello Netology!')

print(" [x] Sent 'Hello Netology!'")

# 5. Закрываем соединение
connection.close()