
import 'package:back_to_us/Models/album.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 //TODO hash password
class AppUser {
  AppUser({
    required this.username,
    required this.email,
    required this.uid,
    required this.createdAt,
    this.albumIds,
    this.profilePic,
    this.isPremium = false,
    this.albums,
  });

  final String username;
  final String email;
  final String uid;
  final String? profilePic;
  final bool isPremium;
  final List<String>? albumIds;
  final Timestamp createdAt;
  final List<Album>? albums;

  //to get user from json
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      username : json["username"],
      email : json["email"],
      uid : json["uid"],
      profilePic : json["profilePic"],
      isPremium : json["isPremium"],
      albumIds : json["albumIds"],
      createdAt : json["createdAt"],
      albums : json["albums"],
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
    "albums" : albums
  };
}

}