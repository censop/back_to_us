
import 'package:back_to_us/Models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseService {
  static AppUser? currentUser;
  
  static Future<void> getAppUser() async {
    User? user = FirebaseAuth.instance.currentUser;
   if (user != null) {
    try {
       DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection("users")
      .doc(user.uid)
      .get();
      currentUser = AppUser.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print(e);
    }
   }
  }
}