import 'package:back_to_us/Services/firebase_service.dart';
import 'package:flutter/material.dart';

ValueNotifier<bool> darkModeNotifier = ValueNotifier(true);

ValueNotifier<String?> profilePicNotifier = ValueNotifier(FirebaseService.currentUser?.profilePic);

ValueNotifier<List<String>?> albumIdsNotifier = ValueNotifier(FirebaseService.currentUser?.albumIds);