

//TODO şimdilik password böyle ama değişecek
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  AppUser({
    required this.username,
    required this.email,
    required this.uid,
    required this.createdAt,
    required this.password,
    this.albumIds,
    this.profilePic,
    this.isPremium = false,
  });

  final String username;
  final String password;
  final String email;
  final String uid;
  final String? profilePic;
  final bool isPremium;
  final List<String>? albumIds;
  final Timestamp createdAt;

  //to get user from json
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      username : json["username"],
      email : json["email"],
      uid : json["uid"],
      profilePic : json["profilePic"],
      isPremium : json["isPremium"],
      albumIds : json["albumIds"],
      password: json["password"],
      createdAt: json["createdAt"],
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
    "albumIds" : albumIds,
    "createdAt" : createdAt,
    "password" : password,
  };
}

}