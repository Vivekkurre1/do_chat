import 'package:do_chat/providers/auth_provider.dart';
import 'package:do_chat/services/cloudinary_service.dart';
import 'package:do_chat/services/database_service.dart';
import 'package:do_chat/services/media_service.dart';
import 'package:do_chat/services/navigation_service.dart';
import 'package:do_chat/widgets/custom_input_fields.dart';
import 'package:do_chat/widgets/rounded_button.dart';
import 'package:do_chat/widgets/rounded_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthProvider _authProvider;
  late DatabaseService _databaseService;
  // late CloudStorageService _cloudStorage;
  late CloudinaryStorageService _cloudinaryStorage;
  late NavigationService _navigationService;
  String? _name;
  String? _email;
  String? _password;

  PlatformFile? _profileImage;

  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
    _databaseService = GetIt.instance.get<DatabaseService>();
    // _cloudStorage = GetIt.instance.get<CloudStorageService>();
    _cloudinaryStorage = GetIt.instance.get<CloudinaryStorageService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileImaeField(),
            SizedBox(height: _deviceHeight * 0.05),
            _registerForm(),
            SizedBox(height: _deviceHeight * 0.05),
            _registerButton(),
            SizedBox(height: _deviceHeight * 0.02),
            _registerAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _profileImaeField() {
    return GestureDetector(
      onTap: () async {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then((file) {
          setState(() {
            _profileImage = file;
          });
        });
      },
      child: () {
        if (_profileImage != null) {
          return RoundedImageFile(
            key: UniqueKey(),
            image: _profileImage!,
            size: _deviceHeight * 0.15,
          );
        } else {
          return RoundedImageNetwork(
            key: UniqueKey(),
            imagePath:
                "https://static.tvtropes.org/pmwiki/pub/images/marky_1.png",
            size: _deviceHeight * 0.15,
          );
        }
      }(),
    );
  }

  Widget _registerForm() {
    return Container(
      height: _deviceHeight * 0.22,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomInputFields(
              onSaved: (value) {
                setState(() {
                  _name = value;
                });
              },
              hintText: "Name",
              obscureText: false,
              regEx: r".{8,}",
            ),
            // SizedBox(height: _deviceHeight * 0.01),
            CustomInputFields(
              onSaved: (value) {
                setState(() {
                  _email = value;
                });
              },
              hintText: "Email",
              obscureText: false,
              regEx: r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
            ),
            // SizedBox(height: _deviceHeight * 0.01),
            CustomInputFields(
              onSaved: (value) {
                setState(() {
                  _password = value;
                });
              },
              hintText: "Password",
              obscureText: true,
              regEx: r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$",
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
      name: "Register",
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPressed: () async {
        if (_registerFormKey.currentState!.validate() &&
            _profileImage != null) {
          _registerFormKey.currentState!.save();
          try {
            final uid = await _authProvider.registerUsingEmailAndPassword(
              _email!,
              _password!,
            );

            if (uid == null) {
              throw Exception("Failed to register user.");
            }

            final imageUrl = await _cloudinaryStorage.saveUserImageToCloudinary(
              uid,
              _profileImage!,
            );

            await _databaseService.createUser(
              uid,
              _name!,
              _email!,
              imageUrl ?? "",
            );
            // await _authProvider.logout();
            // await _authProvider.loginUsingEmailAndPassword(
            //   email: _email!,
            //   password: _password!,
            // );

            await _authProvider.getDataFromFirebase();
            // _navigationService.goBack();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Registration failed: ${e.toString()}")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Please fill all fields and select a profile image.",
              ),
            ),
          );
        }
      },
    );
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () {
        _navigationService.navigateToRoute('/login');
      },
      child: Container(
        height: _deviceHeight * 0.03,
        child: const Text(
          "Already have an account? Login",
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
