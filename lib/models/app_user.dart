
import 'package:cloud_firestore/cloud_firestore.dart';
 //TODO hash password
class AppUser {
  AppUser({
    required this.username,
    required this.email,
    required this.uid,
    required this.createdAt,
    required this.friendInviteId,
    this.profilePic,
    this.isPremium = false,
    this.friends = const [],
  });

  final String username;
  final String email;
  final String uid;
  final String? profilePic;
  final bool isPremium;
  final String friendInviteId;
  final Timestamp createdAt;
  final List<String?> friends;

  //to get user from json
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      username : json["username"],
      email : json["email"],
      uid : json["uid"],
      profilePic : json["profilePic"] as String?,
      isPremium : json["isPremium"],
      createdAt : json["createdAt"],
      friends: List<String>.from(json['friends'] ?? []),
      friendInviteId: json["friendInviteId"],
    );
  }

  //to turn user intojson to put is firestore
  Map<String, dynamic> toJson() {
    return {
      "username" : username,
      "email" : email,
      "uid" : uid,
      "profilePic" : profilePic,
      "isPremium" : isPremium,
      "createdAt" : createdAt,
      "friends" : friends,
      "friendInviteId" : friendInviteId
    };
  }
}