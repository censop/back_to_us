
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
    print('Firebase Auth user: ${user?.uid}');
    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
        print('Document exists: ${doc.exists}');
        print('Document data: ${doc.data()}');
        currentUser = AppUser.fromJson(doc.data() as Map<String, dynamic>);
        albumIdsNotifier.value = currentUser?.albumIds;
        profilePicNotifier.value = currentUser?.profilePic;
      } catch (e) {
        print('Error in getAppUser: $e');
      }
    }
    else {
      print('No authenticated user found');
    }
  }

  static void logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    FirebaseService.currentUser = null;
    albumIdsNotifier.value = null;
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

  static Future<void> addAlbumId(String id) async {
    await FirebaseFirestore.instance
    .collection("users")
    .doc(FirebaseService.currentUser!.uid)
    .update({
      "albumIds" : FieldValue.arrayUnion([id]),
    });

    await FirebaseService.getAppUser();
  }

  static Future<void> removeAlbumId(String id) async {
    await FirebaseFirestore.instance
    .collection("users")
    .doc(FirebaseService.currentUser!.uid)
    .update({
      "albumIds" : FieldValue.arrayRemove([id]),
    });

    await FirebaseService.getAppUser();
  }
}
