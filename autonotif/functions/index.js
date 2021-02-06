const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

var msgData;
exports.presensiTrigger = functions.firestore.document(
    'presensi/{presensiId}'
).onCreate((snapshot, context) => {
    msgData = snapshot.data();

    admin.firestore().collection('userDatas/{token}').get().then((snapshot) => {
        var tokens = [];
        if (snapshot.empty) {
            console.log("No Devices");
        } else {
            for(var token of snapshot.docs) {
                tokens.push(token.data().token); 
            }

            var payload = {
                "notifications" : {
                    "title": "Pemberitahuan",
                    "body": "Mata Kuliah" + msgData.mata_kuliah +"\nKelas" +msgData.kelas + "\nJam" + msgData.jam + "\nRuang" +msgData.ruang + "\nKeterangan" + msgData.keterangan,
                    "sound" : "default"
                },
                "data": {
                    "sendername" : msgData.firestore().collection("userDatas/{email}").get(),
                    "message" : "Mata Kuliah" + msgData.mata_kuliah +"\nKelas" +msgData.kelas + "\nJam" + msgData.jam + "\nRuang" +msgData.ruang + "\nKeterangan" + msgData.keterangan,
                }
            }
            return admin.messaging().sendToDevice(tokens, payload).then((response) => {
                console.log('Pushed.')
            }).catch((err) => {
                console.log(err);
            })
        }
    })
})