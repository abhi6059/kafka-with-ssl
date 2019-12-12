// var express = require("express");
// var app = express();

// app.post("/", (req, res) => {
//   //  res.json(["Hello World"]);
//   //  var fs = require("fs");
//    var topic = req.query.topic;
//   //  var kafkaClientOption = {
//   //   // clientId: 'kafkaadmin',
//   //   kafkaHost : 'localhost:9092',
//   //   ssl: true,
//   //   sslOptions: {
//   //     rejectUnauthorized: false,
//   //     ca: [fs.readFileSync('/home/abhishek/Downloads/kafka_2.12-2.3.0/security/CARoot.pem', 'utf-8')],
//   //     cert: [fs.readFileSync('/home/abhishek/Downloads/kafka_2.12-2.3.0/security/certificate.pem', 'utf-8')],
//   //     key: [fs.readFileSync('/home/abhishek/Downloads/kafka_2.12-2.3.0/security/key.pem', 'utf-8')],
//   //     checkServerIdentity: () => { 
//   //       // console.log('overriding');
//   //       return undefined; 
//   //   }
//   //   //   passphrase: "mypass"
//   //   },
//   //   autoConnect: true,
//   //   connectTimeout: 1000,
//   //   requestTimeout: 1000
//   // }

//   var kafkaClientOption = {
//     // clientId: 'kafkaadmin',
//     kafkaHost : 'localhost:9092',
//     autoConnect: true,
//     connectTimeout: 1000,
//     requestTimeout: 1000
//   }

//   var kafka = require("kafka-node"),
//   Consumer = kafka.Consumer,
// //   client = new kafka.KafkaClient(),
//   client = new kafka.KafkaClient(kafkaClientOption),
//   consumer = new Consumer(
//     client,
//     [
//         { topic: topic, partition: 0 }
//     ],
//     {
//         autoCommit: false
//     });

//   consumer.on("message", function(message) {
//     console.log(message);
//   });

//   consumer.on('error', function (err) {})

//   return res.jsonp({
//     topic:topic
//     // msg:message
//   })
//   });

// app.listen(3001, () => {
//  console.log("Server running on port 3001");
// });





//////////////////////////////////////////////////////////////////
var readline = require('readline-sync');

// var name = readline.question("What is your name?");

// console.log("Hi " + name + ", nice to meet you.");
var topic = readline.question("Enter topic:");


  var kafkaClientOption = {
    // clientId: 'kafkaadmin',
    kafkaHost : 'localhost:9092',
    autoConnect: true,
    connectTimeout: 1000,
    requestTimeout: 1000
  }

  var kafka = require("kafka-node"),
  Consumer = kafka.Consumer,
//   client = new kafka.KafkaClient(),
  client = new kafka.KafkaClient(kafkaClientOption),
  consumer = new Consumer(
    client,
    [
        { topic: topic, partition: 0 }
    ],
    {
        autoCommit: false
    });

  consumer.on("message", function(message) {
    console.log(message.value);
  });

  consumer.on('error', function (err) {})

  // return res.jsonp({
  //   topic:topic
    // msg:message
  // })
