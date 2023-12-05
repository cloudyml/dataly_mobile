
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataly_app/models/UserModel.dart';

class UserServices{
  FirebaseFirestore _firestore=FirebaseFirestore.instance;

  Future<UserModel> getUserById(String id)=>
    _firestore.collection('Users_dataly').doc(id).get().then((doc) {
      return UserModel.fromSnapShot(doc);
    });



}