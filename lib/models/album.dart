import 'package:back_to_us/Models/album_item.dart';
import 'package:back_to_us/Models/album_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//to be improved

class Album {
  final String id;                  // Firestore doc ID
  final String name;                // Album name
  final AlbumMode mode;             // Single / Couple / Friends / Friends+
  final List<String> members;       // List of UIDs who can access
  final String coverPath;           // Storage path to cover photo
  final DateTime openAt;            // When album unlocks
  final bool notificationsEnabled;  // Notifications toggle
  final List<AlbumItem> items;      // Album contents

  Album({
    required this.id,
    required this.name,
    required this.mode,
    required this.members,
    required this.coverPath,
    required this.openAt,
    this.notificationsEnabled = true,
    this.items = const [],
  });

  /// Computed property → how long until it opens
  Duration get timeUntilOpen => openAt.difference(DateTime.now());

  /// Computed property → whether it is currently open
  bool get isOpen {
    final now = DateTime.now();
    return now.isAfter(openAt);
  }

  factory Album.fromJson(String id, Map<String, dynamic> data, [List<AlbumItem> items = const []]) {
    return Album(
      id: id,
      name: data['name'],
      mode: AlbumMode.fromName(data['mode']),
      members: List<String>.from(data['members']),
      coverPath: data['coverPath'],
      openAt: (data['openAt'] as Timestamp).toDate(),
      notificationsEnabled: data['notificationsEnabled'] ?? true,
      items: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "mode": mode.name,
      "members": members,
      "coverPath": coverPath,
      "openAt": openAt,
      "notificationsEnabled": notificationsEnabled,
    };
  }
}
