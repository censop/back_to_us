
import 'package:back_to_us/Models/album.dart';
import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


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
        print('Error in getAppUser: $e');
      }
    }
  }

  static void logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    FirebaseService.currentUser = null;
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
    
  }

  /// STREAMS
  static Stream<String?> profilePicStream() {
  if (currentUser == null) {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection("users")
      .doc(currentUser!.uid)
      .snapshots()
      .map((snapshot) {
        if (!snapshot.exists) return null;
        final data = snapshot.data() as Map<String, dynamic>;
        return data["profilePic"] as String?;
      });
}

  static Stream<List<Album>> getUserAlbums() {

    if (currentUser == null) {
      return const Stream.empty();
    }

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

  static Stream<List<Map<String, dynamic>>> getUserInvites() {
    if (currentUser == null) {
      return const Stream.empty();
    }

    return invitesRef
        .where('to', isEqualTo: currentUser!.uid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }



  /// FRIEND INVITES
  
  static final CollectionReference invitesRef = FirebaseFirestore.instance.collection('friendInvites');
  static final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  static Future<String?> createInviteLink() async {
    if (currentUser == null) {
      return null;
    }

    String inviteId = const Uuid().v4();

    await invitesRef.doc(inviteId).set({
      'from': currentUser!.uid,
      'to': null,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return 'https://backtous.app/friend-invite/$inviteId';
  }

  static Future<bool> acceptFriendInvite(String inviteId) async {
    if (currentUser == null) return false;

    final inviteDoc = invitesRef.doc(inviteId);
    final snapshot = await inviteDoc.get();

    if (!snapshot.exists) return false;

    final data = snapshot.data() as Map<String, dynamic>;
    if (data['status'] != 'pending') return false;

    final senderUid = data['from'] as String;

    await inviteDoc.update({
      'to': currentUser!.uid,
      'status': 'accepted',
    });

    await usersRef.doc(senderUid).update({
      'friends': FieldValue.arrayUnion([currentUser!.uid]),
    });

    await usersRef.doc(currentUser!.uid).update({
      'friends': FieldValue.arrayUnion([senderUid]),
    });

    await getAppUser(); 

    return true;
  }

  static Future<void> declineFriendInvite(String inviteId) async {
    if (currentUser == null) return;

    final inviteDoc = invitesRef.doc(inviteId);
    final snapshot = await inviteDoc.get();

    if (!snapshot.exists) return;

    final data = snapshot.data() as Map<String, dynamic>;
    if (data['status'] != 'pending') return;

    await inviteDoc.update({
      'to': currentUser!.uid,
      'status': 'declined',
    });
  }


  
}
