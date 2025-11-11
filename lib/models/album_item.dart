
import 'package:back_to_us/Models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//will be improved
enum AlbumItemType { 
    photo,
    video,
    voice,
    text,
    drawing, 
}

class AlbumItem {
  final String id;               
  final String storagePath;      
  final AlbumItemType type;
  final AppUser createdBy;        
  final DateTime createdAt;       
  final String downloadUrl;

  AlbumItem({
    required this.id,
    required this.storagePath,
    required this.type,
    required this.createdBy,
    required this.createdAt,
    required this.downloadUrl
  });

  factory AlbumItem.fromMap(String id, Map<String, dynamic> data) {
    return AlbumItem(
      id: id,
      storagePath: data['storagePath'],
      type: AlbumItemType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => AlbumItemType.photo,
      ),
      createdBy:  AppUser.fromJson(Map<String, dynamic>.from(data['createdBy'] as Map)),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      downloadUrl: data["downloadUrl"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "storagePath": storagePath,
      "type": type.name,
      "createdBy": createdBy.toJson(),
      "createdAt": createdAt,
      "downloadUrl": downloadUrl,
    };
  }
}
