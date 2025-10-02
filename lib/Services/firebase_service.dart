
import 'package:back_to_us/Models/album.dart';
import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/Services/notifiers.dart';
import 'package:back_to_us/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


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
        profilePicNotifier.value = currentUser?.profilePic;
      } catch (e) {
        print('Error in getAppUser: $e');
      }
    }
  }

  static void logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    FirebaseService.currentUser = null;
    profilePicNotifier.value = null;
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.welcome, 
      (Route<dynamic> route) => false,
    );
  }

  static void forgotPassword(BuildContext context) {
    Navigator.pushNamed(
      context,
      Routes.forgotPassword,
    );
  }

  static Future<void> updateProfilePictureUrl(Reference ref) async {
    final url = await ref.getDownloadURL();

    FirebaseFirestore.instance
    .collection("users")
    .doc(FirebaseService.currentUser!.uid)
    .update({
      "profilePic" : url,
    });

    await FirebaseService.getAppUser();

    profilePicNotifier.value = url;
    
  }

  static Stream<List<Album>> getUserAlbums() {
    final uid = FirebaseService.currentUser!.uid;

    return FirebaseFirestore.instance
      .collection("albums")
      .where("members", arrayContains: uid)
      .snapshots()
      .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Album.fromJson(doc.id, doc.data());
      }).toList();
    });
  }
}
