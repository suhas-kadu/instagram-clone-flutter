import 'dart:typed_data';
import 'package:flutter/material.dart';
import "package:flutter_svg/svg.dart";
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/global_variables.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:instagram_clone_flutter/views/login_screen.dart';
import 'package:instagram_clone_flutter/views/verify_email_screen.dart';
import 'package:instagram_clone_flutter/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;

  selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  void signupuser() async {
    if (_image == null) {
      showSnackBar(context, "Please select an image");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );

    print(res);
    if (res != "success") {
      showSnackBar(context, res);
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => VerifyEmailScreen()));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? circularProgressIndicator
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 64,
                      ),
                      // instagram logo
                      SvgPicture.asset(
                        "assets/images/instagram_logo.svg",
                        color: primaryColor,
                        height: 64,
                      ),

                      const SizedBox(height: 32),

                      Stack(
                        children: [
                          _image == null
                              ? const CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                      "https://t4.ftcdn.net/jpg/02/15/84/43/240_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg"),
                                )
                              : CircleAvatar(
                                  radius: 64,
                                  backgroundImage: MemoryImage(_image!),
                                ),
                          Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                onPressed: () {
                                  selectImage();
                                },
                                icon: const Icon(Icons.add_a_photo),
                              ))
                        ],
                      ),

                      const SizedBox(height: 48),

                      // username
                      TextFieldInput(
                          textEditingController: _usernameController,
                          hintText: "Enter your username",
                          textInputType: TextInputType.text),

                      const SizedBox(height: 24),

                      // bio
                      TextFieldInput(
                          textEditingController: _bioController,
                          hintText: "Enter your Bio",
                          textInputType: TextInputType.text),

                      const SizedBox(height: 24),

                      // email
                      TextFieldInput(
                          textEditingController: _emailController,
                          hintText: "Enter your email",
                          textInputType: TextInputType.emailAddress),

                      const SizedBox(height: 24),
                      // password
                      TextFieldInput(
                        textEditingController: _passwordController,
                        hintText: "Enter your password",
                        textInputType: TextInputType.visiblePassword,
                        isPassword: true,
                      ),

                      const SizedBox(height: 24),

                      // login button
                      InkWell(
                        onTap: () {
                          signupuser();
                        },
                        child: Container(
                          child: const Text("Signup"),
                          width: double.infinity,
                          decoration: ShapeDecoration(
                              color: blueColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              )),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          alignment: Alignment.center,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // navigating to sign up page
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account ?"),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen())),
                            child: const Text(
                              " Login here",
                              style: TextStyle(color: blueColor),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ));
  }
}
