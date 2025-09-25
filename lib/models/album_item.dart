
import 'package:cloud_firestore/cloud_firestore.dart';
//will be improved
enum AlbumItemType { photo, video, audio, note }

class AlbumItem {
  final String id;               // Firestore doc ID
  final String storagePath;      // Firebase Storage path
  final AlbumItemType type;
  final String createdBy;        // uid of uploader
  final DateTime createdAt;
  final String? caption;         // optional

  AlbumItem({
    required this.id,
    required this.storagePath,
    required this.type,
    required this.createdBy,
    required this.createdAt,
    this.caption,
  });

  factory AlbumItem.fromMap(String id, Map<String, dynamic> data) {
    return AlbumItem(
      id: id,
      storagePath: data['storagePath'],
      type: AlbumItemType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => AlbumItemType.photo,
      ),
      createdBy: data['createdBy'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      caption: data['caption'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "storagePath": storagePath,
      "type": type.name,
      "createdBy": createdBy,
      "createdAt": createdAt,
      "caption": caption,
    };
  }
}
