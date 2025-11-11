
import 'dart:io';
import 'package:back_to_us/Models/album.dart';
import 'package:back_to_us/Models/album_item.dart';
import 'package:back_to_us/Models/app_user.dart';
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

  static Future<AppUser> getAppUserByUid(String uid) async {
    final doc = await FirebaseFirestore.instance
    .collection("users")
    .doc(uid)
    .get();

    return AppUser.fromJson(doc.data() as Map<String, dynamic>);

  }

  static Future<void> addItemToAlbum(String albumId, AlbumItemType type, File file, AppUser createdBy, {String? caption}) async {
    final docRef = FirebaseFirestore.instance.collection('albums').doc(albumId).collection('items').doc();

    final storagePath = 'albums/$albumId/items/${docRef.id}/file.${_getExtension(type)}';

    final uploadTask = await FirebaseStorage.instance.ref(storagePath).putFile(file);

    final downloadUrl = await uploadTask.ref.getDownloadURL();

    final newItem = AlbumItem(
      id: docRef.id,
      storagePath: storagePath, 
      type: type,
      createdBy: createdBy,
      createdAt: DateTime.now(),
      downloadUrl: downloadUrl
    );
    
    await docRef.set(newItem.toMap());
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

  static Stream<List<Album>> albumStream() {

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

  static Stream<List<AlbumItem>> albumItemsStream(String albumId, bool descending) {
    if (albumId.isEmpty) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
      .collection('albums')
      .doc(albumId)
      .collection('items')
      .orderBy('createdAt', descending: descending)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => AlbumItem.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList());
  }

  static Stream<List<Map<String, dynamic>>> pendingInvitesStream() {
    if (currentUser == null) return const Stream.empty();

    return invitesRef
        .where('to', isEqualTo: currentUser!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList());
  }

  static Stream<List<AppUser>> friendsStream() {
    if (currentUser == null) return const Stream.empty();

    return usersRef.doc(currentUser!.uid).snapshots().asyncMap((snapshot) async {
      if (!snapshot.exists) return [];

      final data = snapshot.data() as Map<String, dynamic>;
      final friendUids = List<String>.from(data['friends'] ?? []);

      if (friendUids.isEmpty) return [];

      final friendsSnap = await usersRef
          .where(FieldPath.documentId, whereIn: friendUids)
          .get();

      return friendsSnap.docs
          .map((doc) => AppUser.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  static Stream<List<AppUser>> albumMembersStream(List<String> memberUids) {
  if (memberUids.isEmpty) return const Stream.empty();

  return usersRef
      .where(FieldPath.documentId, whereIn: memberUids)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => AppUser.fromJson(doc.data() as Map<String, dynamic>))
          .toList());
  }




  /// FRIEND INVITES
  static final CollectionReference invitesRef =
      FirebaseFirestore.instance.collection('friendInvites');
  static final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');
  static final CollectionReference inviteCodesRef = 
      FirebaseFirestore.instance.collection('friendInviteIds');

  /// Send a friend invite to a specific user
  static Future<bool> sendFriendInvite(String friendInviteId) async {
    if (currentUser == null) return false;

    final inviteDoc = await inviteCodesRef.doc(friendInviteId).get();
    if (!inviteDoc.exists) {
      print("Invalid invite code");
      return false;
    }

    final receiverUid = (inviteDoc.data() as Map<String, dynamic>)["uid"];
    final senderUid = currentUser!.uid;


    if (receiverUid == senderUid) {
      print("You can’t add yourself");
      return false;
    }

    try {
      final existing = await invitesRef
        .where('from', isEqualTo: currentUser!.uid)
        .where('to', isEqualTo: receiverUid)
        .get();

      if (existing.docs.isNotEmpty) return false;

      await invitesRef.add({
        'from': currentUser!.uid,
        'to': receiverUid,
        'createdAt': FieldValue.serverTimestamp(),
        'senderInviteId': currentUser!.friendInviteId,
        'senderUsername': currentUser!.username,
        'senderPhoto': currentUser!.profilePic,
    });
    } catch (e) {
      print(e);
    }
    
    return true;
  }

  /// Accept a friend invite
  static Future<bool> acceptFriendInvite(String inviteId) async {
    if (currentUser == null) return false;

    final inviteDoc = invitesRef.doc(inviteId);
    final snapshot = await inviteDoc.get();
    if (!snapshot.exists) return false;

    final data = snapshot.data() as Map<String, dynamic>;

    final senderUid = data['from'] as String;

    final batch = FirebaseFirestore.instance.batch();

    batch.update(usersRef.doc(senderUid), {
      'friends': FieldValue.arrayUnion([currentUser!.uid])
    });
    batch.update(usersRef.doc(currentUser!.uid), {
      'friends': FieldValue.arrayUnion([senderUid])
    });

    batch.delete(inviteDoc);

    await batch.commit();

    await getAppUser(); 

    return true;
  }

  /// Decline a friend invite
  static Future<void> declineFriendInvite(String inviteId) async {
    if (currentUser == null) return;

    final inviteDoc = invitesRef.doc(inviteId);
    final snapshot = await inviteDoc.get();
    if (!snapshot.exists) return;

    await inviteDoc.delete();
  }

  static String _getExtension(AlbumItemType type) {
    switch (type) {
      case AlbumItemType.photo:
        return 'jpg';
      case AlbumItemType.video:
        return 'mp4';
      case AlbumItemType.voice:
        return 'm4a';
      case AlbumItemType.text:
        return 'txt';
      case AlbumItemType.drawing:
        return 'png';
    }
  }

}
