mkdir security

cd security

#1.create a server keystore
keytool -keystore kafka.server.keystore.jks -alias localhost -validity 3600 -genkey

#2.create ca-certificate and ca-key
openssl req -new -x509 -keyout ca-key -out ca-cert -days 3600

#3.import ca-certificate to server truststore (server truststore is created)
keytool -keystore kafka.server.truststore.jks -alias CARoot -import -file ca-cert

#4.import ca-certificate to client truststore (client truststore is created)
keytool -keystore kafka.client.truststore.jks -alias CARoot -import -file ca-cert

#5.req cert-file from server keystore (cert-file is extracted from server keystore)
keytool -keystore kafka.server.keystore.jks -alias localhost -certreq -file server-cert-file

#6.sign cert-file using CA
openssl x509 -req -CA ca-cert -CAkey ca-key -in server-cert-file -out server-cert-signed -days 3600 -CAcreateserial -passin pass:ramco@123

#7.import ca-certificate to server keystore (ca-cert is imported)
keytool -keystore kafka.server.keystore.jks -alias CARoot -import -file ca-cert

#8.import signed certificate to server keystore (cert-signed is imported)
keytool -keystore kafka.server.keystore.jks -alias localhost -import -file server-cert-signed

#9.create a client keystore
keytool -keystore kafka.client.keystore.jks -alias localhost -validity 3600 -genkey

#10.req client-cert-file from client keystore (client-cert-file is created)
keytool -keystore kafka.client.keystore.jks -alias localhost -certreq -file client-cert-file

#11.sign client cert using ca cert and ca key (client-cert-signed is created)
openssl x509 -req -CA ca-cert -CAkey ca-key -in client-cert-file -out client-cert-signed -days 3600 -CAcreateserial -passin pass:ramco@123

#12.import ca-cert to client keystore 
keytool -keystore kafka.client.keystore.jks -alias CARoot -import -file ca-cert

#13.import client-cert-signed to client keystore
keytool -keystore kafka.client.keystore.jks -alias localhost -import -file client-cert-signed


#1.to check content of server keystore
#keytool -list -rfc -keystore kafka.client.keystore.jks

#2.creation of certificate.pem - we will extract the client certificate:
keytool -exportcert -alias localhost -keystore kafka.client.keystore.jks -rfc -file certificate.pem

#3.Next we will extract the clients key
#3.1.This is not supported directly by keytool, which is why we have to convert the keystore to pkcs12 format first
#3.2.then extract the private key from that:
keytool -v -importkeystore -srckeystore kafka.client.keystore.jks -srcalias localhost -destkeystore cert_and_key.p12 -deststoretype PKCS12
#openssl pkcs12 -in cert_and_key.p12 -nocerts -nodes

#3.3 create key.pem file
openssl pkcs12 -in cert_and_key.p12 -nocerts -nodes >> key.pem
#nano key.pem

#The second command only prints the key to STDOUT
#From there it can be copied and pasted into ‘key.pem’. 
#(Make sure to copy the lines inclusive between —–BEGIN PRIVATE KEY—– and —–END PRIVATE KEY—–)

#4.Finally we will extract the CARoot certificate
keytool -exportcert -alias CARoot -keystore kafka.client.keystore.jks -rfc -file CARoot.pem

#5.Add keystore password to file
echo "ramco@123" >> keystore-creds

#6.Add key password to file
echo "ramco@123" >> key-creds

#7.Add truststore password to file
echo "ramco@123" >> truststore-creds



####################################################################################################

#if you are running kafka on localhost

#changes in config/server.properties:-

#listeners=SSL://:9092
#ssl.keystore.location=/opt/ngt/poc/kafka/kafka_2.12-2.3.0/security/kafka.server.keystore.jks
#ssl.keystore.password=ramco@123
#ssl.key.password=ramco@123
#ssl.truststore.location=/opt/ngt/poc/kafka/kafka_2.12-2.3.0/security/kafka.server.truststore.jks
#ssl.truststore.password=ramco@123
#ssl.client.auth=required
#security.inter.broker.protocol=SSL
#ssl.enabled.protocols=TLSv1.2,TLSv1.1,TLSv1
#ssl.keystore.type=JKS
#ssl.truststore.type=JKS
#ssl.endpoint.identification.algorithm=


#new file config/client-ssl.properties:-

#security.protocol=SSL
#ssl.truststore.location=/opt/ngt/poc/kafka/kafka_2.12-2.3.0/security/kafka.client.truststore.jks
#ssl.truststore.password=ramco@123
#ssl.endpoint.identification.algorithm=
#ssl.keystore.location=/opt/ngt/poc/kafka/kafka_2.12-2.3.0/security/kafka.client.keystore.jks
#ssl.keystore.password=ramco@123
#ssl.key.password=ramco@123
#ssl.enabled.protocols=TLSv1.2,TLSv1.1,TLSv1
#ssl.truststore.type=JKS
#ssl.keystore.type=JKS

#then run using
#bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test --producer.config config/client-ssl.properties

#bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --consumer.config config/client-ssl.properties

#####################################################################################################

#if kafka is running in container then:

#add these to docker-compose file:
#1.To Kafka service
#in environment add these:
#KAFKA_ADVERTISED_LISTENERS: SSL://${HOST_IP}:19092
#KAFKA_SSL_ENABLED_PROTOCOLS: TLSv1.2,TLSv1.1,TLSv1
#KAFKA_SSL_TRUSTSTORE_TYPE: JKS
#KAFKA_SSL_KEYSTORE_TYPE: JKS
#KAFKA_SSL_KEYSTORE_CREDENTIALS: keystore-creds
#KAFKA_SSL_KEY_CREDENTIALS: key-creds
#KAFKA_SSL_TRUSTSTORE_CREDENTIALS: truststore-creds
#KAFKA_SSL_CLIENT_AUTH: required
#KAFKA_SECURITY_INTER_BROKER_PROTOCOL: SSL 
#KAFKA_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM: " "
#KAFKA_SSL_KEYSTORE_FILENAME: kafka.server.keystore.jks
#KAFKA_SSL_TRUSTSTORE_FILENAME: kafka.server.truststore.jks

#in volume (mount the certificates):
#- ${ROOT_PLATFORM}/kafka/security/kafka.server.keystore.jks:/etc/kafka/secrets/kafka.server.keystore.jks
#- ${ROOT_PLATFORM}/kafka/security/kafka.server.truststore.jks:/etc/kafka/secrets/kafka.server.truststore.jks
#- ${ROOT_PLATFORM}/kafka/security/keystore-creds:/etc/kafka/secrets/keystore-creds
#- ${ROOT_PLATFORM}/kafka/security/key-creds:/etc/kafka/secrets/key-creds
#- ${ROOT_PLATFORM}/kafka/security/truststore-creds:/etc/kafka/secrets/truststore-creds

#2.To kafka-consumer and kafka-producer service add these:
#in volume (mount pem files)
#- ${ROOT_PLATFORM}/kafka/security/CARoot.pem:/app/server/src/CARoot.pem
#- ${ROOT_PLATFORM}/kafka/security/certificate.pem:/app/server/src/certificate.pem
#- ${ROOT_PLATFORM}/kafka/security/key.pem:/app/server/src/key.pem


#add the following while connecting to producer and consumer file under client=new KafkaClient() (note:-for node.js code only):

#       ssl: true,
#       sslOptions: {
#            rejectUnauthorized: false,
#            ca: [fs.readFileSync('/app/server/src/CARoot.pem', 'utf-8')],
#            cert: fs.readFileSync('/app/server/src/certificate.pem', 'utf-8'),
#            key: fs.readFileSync('/app/server/src/key.pem', 'utf-8'),
#            checkServerIdentity: () => { 
#                  return undefined; 
#              }
#        }

#to run this script "chmod +x file_name"
