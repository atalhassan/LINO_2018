import firebase from 'firebase/app'


// Initialize Firebase
var prodConfig = {
  apiKey: "AIzaSyBvmS_5SD6-OsItntOs_dnLFcjbi_lIsJ8",
  authDomain: "lino2018-ad380.firebaseapp.com",
  databaseURL: "https://lino2018-ad380.firebaseio.com",
  projectId: "lino2018-ad380",
  storageBucket: "lino2018-ad380.appspot.com",
  messagingSenderId: "23249420192"
};

var devConfig = {
  apiKey: "AIzaSyBvmS_5SD6-OsItntOs_dnLFcjbi_lIsJ8",
  authDomain: "lino2018-ad380.firebaseapp.com",
  databaseURL: "https://lino2018-ad380.firebaseio.com",
  projectId: "lino2018-ad380",
  storageBucket: "lino2018-ad380.appspot.com",
  messagingSenderId: "23249420192"
};

const config = process.env.NODE_ENV === 'production'
  ? prodConfig
  : devConfig;


if (!firebase.apps.length) {
  firebase.initializeApp(config);
}


const db = firebase.database();
const auth = firebase.auth();

export {
  db,
  auth,
}
