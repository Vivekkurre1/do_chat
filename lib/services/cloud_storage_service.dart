import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String USER_COLLECTION = "Users";

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CloudStorageService() {}

  Future<String?> saveUserImageToStorage(
    String _uid,
    PlatformFile _file,
  ) async {
    try {
      Reference ref = _storage.ref().child(
        "images/users/@$_uid/profile.${_file.extension}",
      );
      UploadTask _task = ref.putFile(File(_file.path!));

      return await _task.then((_result) => _result.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> saveChatImageToStorage(
    String _chatId,
    String _userId,
    PlatformFile _file,
  ) async {
    try {
      Reference ref = _storage.ref().child(
        "images/chats/@$_chatId/$_userId/_${Timestamp.now().millisecondsSinceEpoch}.${_file.extension}",
      );
      UploadTask _task = ref.putFile(File(_file.path!));

      return await _task.then((_result) => _result.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
    return null;
  }
}
