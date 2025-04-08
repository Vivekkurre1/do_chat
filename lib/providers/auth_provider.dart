import 'package:do_chat/model/chat_user.dart';
import 'package:do_chat/services/database_service.dart';
import 'package:do_chat/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class AuthProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late DatabaseService _databaseService;

  late ChatUser user;

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance<NavigationService>();
    _databaseService = GetIt.instance<DatabaseService>();

    // _auth.signOut();

    _auth.authStateChanges().listen((_user) {
      if (_user != null) {
        _databaseService.updateUserLasSeenTime(_user.uid);
        _databaseService.getUser(_user.uid).then((_snapshot) {
          Map<String, dynamic> userData =
              _snapshot.data()! as Map<String, dynamic>;
          user = ChatUser.fromJson({
            'uId': _user.uid,
            'name': userData['name'],
            'email': userData['email'],
            'imageUrl': userData['imageUrl'],
            'lastActive': userData['lastActive'],
          });
          _navigationService.removeAndavigateToRoute('/home');
        });
        if (kDebugMode) {
          print("user is logged in");
        }
      } else {
        _navigationService.removeAndavigateToRoute('/login');
        if (kDebugMode) {
          print("user is not logged in");
        }
      }
    });
  }

  Future<void> loginUsingEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (kDebugMode) {
        print(_auth.currentUser);
      }
    } on FirebaseAuthException {
      if (kDebugMode) {
        print('Error occurred while logging in');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<String?> registerUsingEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (kDebugMode) {
        print(userCredential.user);
      }
      return userCredential.user?.uid;
    } on FirebaseAuthException {
      if (kDebugMode) {
        print("Error occurred while registering");
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      if (kDebugMode) {
        print("User logged out");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
