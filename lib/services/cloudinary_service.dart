import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class CloudinaryStorageService {
  final String cloudName = "dnjeaojih";
  final String uploadPreset = "flutter_do_chat";

  CloudinaryStorageService();

  Future<String?> _uploadToCloudinary(
    File file,
    String folder,
    String fileName,
  ) async {
    try {
      final mimeType = lookupMimeType(file.path);
      final fileType =
          mimeType?.split('/')[0] ?? 'raw'; // image / video / application

      final resourceType =
          (fileType == 'image' || fileType == 'video') ? fileType : 'raw';

      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/$resourceType/upload',
      );

      final request =
          http.MultipartRequest('POST', uri)
            ..fields['upload_preset'] = uploadPreset
            ..fields['folder'] = folder
            ..fields['public_id'] = fileName
            ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final resStr = await response.stream.bytesToString();
        final resJson = json.decode(resStr);
        return resJson['secure_url'];
      } else {
        print('❌ Failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Upload error: $e');
      return null;
    }
  }

  /// 📤 Upload Profile Image
  Future<String?> saveUserImageToCloudinary(
    String uid,
    PlatformFile file,
  ) async {
    final filename = "profile_$uid";
    final folder = "images/users";
    return await _uploadToCloudinary(File(file.path!), folder, filename);
  }

  /// 📤 Upload Chat Image / PDF / Video
  Future<String?> saveChatFileToCloudinary(
    String chatId,
    String userId,
    PlatformFile file,
  ) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filename = "chat_${userId}_$timestamp";
    final folder = "images/chats/$chatId";
    return await _uploadToCloudinary(File(file.path!), folder, filename);
  }
}
