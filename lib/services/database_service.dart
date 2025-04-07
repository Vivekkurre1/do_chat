import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGE_COLLECTION = "Messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService() {}

  Future<DocumentSnapshot> getUser(String uId) {
    return _db.collection(USER_COLLECTION).doc(uId).get();
  }

  Future<void> updateUserLasSeenTime(String uId) async {
    try {
      await _db.collection(USER_COLLECTION).doc(uId).update({
        'lastSeen': DateTime.now().toUtc(),
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
