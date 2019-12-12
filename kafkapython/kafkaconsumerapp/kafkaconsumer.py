# from flask import Flask,jsonify
# from kafka import KafkaConsumer

# app = Flask(__name__)

# @app.route("/")
# def hello():
#     consumer = KafkaConsumer('MyTopic',bootstrap_servers = 'localhost:9092')
#     for msg in consumer:
#         print(msg,flush=True)
#     return jsonify(msg = "hello world!")


# if __name__ == '__main__':
#     app.run(host="0.0.0.0", port=6002,debug=True)

#Consumer
from kafka import KafkaConsumer

# consumer = KafkaConsumer('topic', bootstrap_servers = ['localhost:9092'],
#                                  security_protocol='SSL',
#                                  ssl_check_hostname=False,
#                                  ssl_cafile='/home/abhishek/Downloads/kafka_2.12-2.3.0/security/CARoot.pem',
#                                  ssl_certfile='/home/abhishek/Downloads/kafka_2.12-2.3.0/security/certificate.pem',
#                                  ssl_keyfile='/home/abhishek/Downloads/kafka_2.12-2.3.0/security/key.pem')

consumer = KafkaConsumer('ramco', bootstrap_servers = ['localhost:9092'])

print("Waiting for msg :")
for msg in consumer:
    if msg.value.decode('utf-8') == 'bye':
        print('msg received :',msg.value.decode('utf-8'),flush=True)
        break
    else:
        print('msg received :',msg.value.decode('utf-8'),flush=True)

