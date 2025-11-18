import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/Services/firebase_service.dart';

class UserCacheService {
  static final Map<String, AppUser> _cache = {};

  static Future<List<AppUser>> getUsers(List<String> uids) async {
    final List<AppUser> results = [];
    final List<String> missingUids = [];

    for (var uid in uids) {
      if (_cache.containsKey(uid)) {
        results.add(_cache[uid]!);
      } else {
        missingUids.add(uid);
      }
    }

    if (missingUids.isEmpty) {
      return results;
    }
    
    final futures = missingUids.map((uid) => FirebaseService.getAppUserByUid(uid));
    final fetchedUsers = await Future.wait(futures);

    for (var user in fetchedUsers) {
      if (user != null) {
        _cache[user.uid] = user;
        results.add(user);
      }
    }

    return results;
  }

  static void clear() {
    _cache.clear();
  }
}