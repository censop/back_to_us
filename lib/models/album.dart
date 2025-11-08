import 'package:back_to_us/Models/album_item.dart';
import 'package:back_to_us/Models/album_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
  final DateTime createdAt;

  Album({
    required this.id,
    required this.name,
    required this.mode,
    required this.members,
    required this.coverPath,
    required this.openAt,
    this.notificationsEnabled = true,
    required this.createdAt, 
    this.items = const [],
  });

  bool get isOpen {
    final now = DateTime.now();
    return now.isAfter(openAt);
  }

  String get readableOpenAt => DateFormat('dd/MM/yyyy').format(openAt);

  String get readableTimeUntilOpen  {
    final now= DateTime.now();

    int years = openAt.year - now.year;
    int months = openAt.month - now.month;
    int days = openAt.day - now.day;
    int hours = openAt.hour - now.hour;
    int minutes = openAt.minute - now.minute;

    if (minutes < 0) {
      minutes += 60;
      hours--;
    }
    if (hours < 0) {
      hours += 24;
      days--;
    }
    if (days < 0) {
      final prevMonth = DateTime(openAt.year, openAt.month, 0);
      days += prevMonth.day;
      months--;
    }
    if (months < 0) {
      months += 12;
      years--;
    }

    final parts = <String>[];
    if (years > 0) parts.add("$years year${years == 1 ? '' : 's'}");
    if (months > 0) parts.add("$months month${months == 1 ? '' : 's'}");
    if (days > 0 && years == 0) parts.add("$days day${days == 1 ? '' : 's'}");
    if (hours > 0 && years == 0 && months == 0) parts.add("$hours hour${hours == 1 ? '' : 's'}");
    if (minutes > 0 && years == 0 && months == 0 && days == 0) {
      parts.add("$minutes minute${minutes == 1 ? '' : 's'}");
    }

    return parts.isEmpty ? "Less than a minute" : "${parts.join(', ')}";
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
      createdAt: (data['createdAt'] as Timestamp).toDate(),
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
      "createdAt": createdAt,
    };
  }
}
