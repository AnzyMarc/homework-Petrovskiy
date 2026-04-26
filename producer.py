import pika

# Данные из твоего docker-compose
credentials = pika.PlainCredentials('andrei', 'ximera')
parameters = pika.ConnectionParameters(host='rmq01', credentials=credentials)

connection = pika.BlockingConnection(parameters)
channel = connection.channel()
channel.queue_declare(queue='hello')

channel.basic_publish(exchange='', routing_key='hello', body='Hello Netology!')
print(" [x] Sent 'Hello Netology!'")
connection.close()