# from flask import Flask,jsonify
# from kafka import KafkaProducer

# app = Flask(__name__)

# @app.route("/")
# def hello():
#     producer = KafkaProducer(bootstrap_servers = 'localhost:9092')
#     producer.send('MyTopic', b'Hello World')
#     return jsonify(msg = "hello world!")


# if __name__ == '__main__':
#     app.run(host="0.0.0.0", port=6001,debug=True)

#Producer
from kafka import KafkaProducer
import time

# producer = KafkaProducer(bootstrap_servers=['localhost:9092'],
#                                  security_protocol='SSL',
#                                  ssl_check_hostname=False,
#                                  ssl_cafile='/home/abhishek/Downloads/kafka_2.12-2.3.0/security/CARoot.pem',
#                                  ssl_certfile='/home/abhishek/Downloads/kafka_2.12-2.3.0/security/certificate.pem',
#                                  ssl_keyfile='/home/abhishek/Downloads/kafka_2.12-2.3.0/security/key.pem')

producer = KafkaProducer(bootstrap_servers=['localhost:9092'])
while(1):
    inp = input('Enter msg :')
    if inp == 'bye':
        producer.send('ramco', inp.encode())
        time.sleep(3)
        break
    else:
        producer.send('ramco', inp.encode())

