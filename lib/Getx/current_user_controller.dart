import 'package:back_to_us/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CurrentUserController extends GetxController{
  AppUser? currentUser;

  void onInit() {
    super.onInit();
    getAppUser();
  }

  Future<void> getAppUser() async {
    try {
       DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .get();
      currentUser = AppUser.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print(e);
    }
  }

}