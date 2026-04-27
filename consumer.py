#!/usr/bin/env python
# coding=utf-8
import pika

credentials = pika.PlainCredentials('admin', 'superpassword')
parameters = pika.ConnectionParameters('localhost', credentials=credentials)
connection = pika.BlockingConnection(parameters)
channel = connection.channel()
channel.queue_declare(queue='hello')


def callback(ch, method, properties, body):
   print(f" [x] Received: {body.decode('utf-8')}")

channel.basic_consume(queue='hello', on_message_callback=callback, auto_ack=True)
channel.start_consuming()