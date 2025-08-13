import 'package:back_to_us/Services/firebase_service.dart';
import 'package:flutter/material.dart';

ValueNotifier<bool> darkModeNotifier = ValueNotifier(true);

ValueNotifier<String?> profilePic = ValueNotifier(FirebaseService.currentUser?.profilePic);