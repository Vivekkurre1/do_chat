// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_chat/model/chat_message.dart';
import 'package:flutter/foundation.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGE_COLLECTION = "messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService() {}

  Future<void> createUser(
    String uid,
    String name,
    String email,
    String imageUrl,
  ) async {
    try {
      await _db.collection(USER_COLLECTION).doc(uid).set({
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
        'lastActive': DateTime.now().toUtc(),
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<DocumentSnapshot> getUser(String uId) {
    return _db.collection(USER_COLLECTION).doc(uId).get();
  }

  Future<QuerySnapshot> getUsers({String? name}) {
    Query query = _db.collection(USER_COLLECTION);
    if (name != null) {
      query = query
          .where("name", isGreaterThanOrEqualTo: name)
          .where("name", isLessThanOrEqualTo: "${name}z");
    }
    return query.get();
  }

  Stream<QuerySnapshot> getChatsForUser(String uid) {
    return _db
        .collection(CHAT_COLLECTION)
        .where("members", arrayContains: uid)
        .snapshots()
        .map((snapshot) {
          if (kDebugMode) {
            print("Chats retrieved for user: ${snapshot.docs.length}");
          }
          return snapshot;
        });
  }

  Future<QuerySnapshot> getLastMessageForChat(String chatId) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(chatId)
        .collection(MESSAGE_COLLECTION)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessageForChat(String chatId) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(chatId)
        .collection(MESSAGE_COLLECTION)
        .orderBy("sent_time", descending: true)
        .snapshots();
  }

  Future<void> addMessageToChat(String chatId, ChatMessage message) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(chatId)
          .collection(MESSAGE_COLLECTION)
          .add(message.toJson());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> deleteChat(String chatId) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(chatId).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<DocumentReference?> createChat(Map<String, dynamic> _data) async {
    try {
      DocumentReference _chat = await _db
          .collection(CHAT_COLLECTION)
          .add(_data);
      return _chat;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<void> updateChat(String chatId, Map<String, dynamic> data) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(chatId).update(data);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
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
