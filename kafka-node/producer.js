// var express = require("express");
// // var bodyParser = require("body-parser");
// var app = express();
// // app.use(express.bodyParser());
// // app.use(bodyParser.json())
// // app.use(bodyparser.urlencoded({
// //     extended:true
// // }));
// app.post("/", (req, res) => {
//   //  res.json(["Hello World"]);

//   //  x = req.body.a;
//   //  console.log('reqbody', req.query.topic);
//    var topic = req.query.topic;
//    var msg = req.query.msg; 
//   //  var fs = require("fs");
//   //  var kafkaClientOption = {
//   //     // clientId: 'kafkaadmin',
//   //     kafkaHost : 'localhost:9092',
//   //     ssl: true,
//   //     sslOptions: {
//   //       rejectUnauthorized: false,
//   //       ca: [fs.readFileSync('/home/abhishek/Downloads/kafka_2.12-2.3.0/security/CARoot.pem', 'utf-8')],
//   //       cert: fs.readFileSync('/home/abhishek/Downloads/kafka_2.12-2.3.0/security/certificate.pem', 'utf-8'),
//   //       key: fs.readFileSync('/home/abhishek/Downloads/kafka_2.12-2.3.0/security/key.pem', 'utf-8'),
//   //       checkServerIdentity: () => { 
//   //             // console.log('overriding');
//   //             return undefined; 
//   //         }
//   //     //   passphrase: ""
//   //   },
//   //   autoConnect: true,
//   //   connectTimeout: 10000,
//   //   requestTimeout: 10000
//   // }

//   var kafkaClientOption = {
//     // clientId: 'kafkaadmin',
//     kafkaHost : 'localhost:9092',
//     autoConnect: true,
//     connectTimeout: 10000,
//     requestTimeout: 10000
// }


//   var kafka = require("kafka-node"),
//   Producer = kafka.Producer,
// //   client = new kafka.KafkaClient(),
//   client = new kafka.KafkaClient(kafkaClientOption),
//   producer = new Producer(client);
  
//   payloads = [
//     { topic: topic, messages: msg, partition: 0 }
//   ];


//   producer.on('ready', function () {
//   console.log('ready now..',payloads[0].topic);

//   producer.createTopics([payloads[0].topic], false, function (err, data) {
//   console.log('topic',data);
//   console.log('topicerr----->', err);
//   });

//   producer.send(payloads, function (err, data) {
//       console.log('data',data);
//       console.log('msgerr----->', err);
//   });
//   });

//   producer.on('error', function (err) {
//   console.log('error in producer', err);
//   })

//   return res.jsonp({
//     topic:topic,
//     msg:msg
//   })
//   });

// app.listen(3000, () => {
//  console.log("Server running on port 3000");
// });

//////////////////////////////////////////////////////////////////

var readline = require('readline-sync');

var topic = readline.question("Topic Name :");
payloads = [];
while(1){
  var msg = readline.question("Enter msg:")
  payloads.push({ topic: topic, messages: msg, partition: 0 })
  if(msg=='bye'){
    break;
  }
}

console.log(payloads);

var kafkaClientOption = {
  kafkaHost : 'localhost:9092',
  autoConnect: true,
  connectTimeout: 10000,
  requestTimeout: 10000
}


var kafka = require("kafka-node"),
Producer = kafka.Producer,
client = new kafka.KafkaClient(kafkaClientOption),
producer = new Producer(client);

producer.on('ready', function () {
// console.log('ready now..');

producer.createTopics([topic], false, function (err, data) {
console.log('topic',topic);
console.log('topicerr----->', err);
});


  producer.send(payloads, function (err, data) {
      console.log('data',data);
      console.log('msgerr----->', err);
  });
});

producer.on('error', function (err) {
console.log('error in producer', err);
})

