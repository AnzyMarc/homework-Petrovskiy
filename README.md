# Домашнее задание к занятию «ELK» Петровский А.Н


### Задание 1. Elasticsearch 

Установите и запустите Elasticsearch, после чего поменяйте параметр cluster_name на случайный. 

*Приведите скриншот команды 'curl -X GET 'localhost:9200/_cluster/health?pretty', сделанной на сервере с установленным Elasticsearch. Где будет виден нестандартный cluster_name*.

---

<details>
<summary> Решение </summary>

<img src="img/task1.png" alt="ElasticSearch" width="100%" health="100%">

</details>


### Задание 2. Kibana

Установите и запустите Kibana.

*Приведите скриншот интерфейса Kibana на странице http://<ip вашего сервера>:5601/app/dev_tools#/console, где будет выполнен запрос GET /_cluster/health?pretty*.

---

<details>
<summary> Решение </summary>

<img src="img/task2.png" alt="kibana" width="100%" health="100%">

</details>


### Задание 3. Logstash

Установите и запустите Logstash и Nginx. С помощью Logstash отправьте access-лог Nginx в Elasticsearch. 

*Приведите скриншот интерфейса Kibana, на котором видны логи Nginx.*

---

<details>
<summary> Решение </summary>
 
 ### DevTools
<img src="img/task3.png" alt="devtools" width="100%" health="100%">

-------------------------

### Discover

<img src="img/task3.png" alt="discover" width="100%" health="100%">

</details>