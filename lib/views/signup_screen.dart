import 'package:flutter/material.dart';
import "package:flutter_svg/svg.dart";
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/views/login_screen.dart';
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
        body: SafeArea(
            child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(flex: 2, child: Container()),
          // instagram logo
          SvgPicture.asset(
            "assets/images/instagram_logo.svg",
            color: primaryColor,
            height: 64,
          ),

          const SizedBox(height: 32),

          Stack(
            children: [
              CircleAvatar(
                radius: 64,
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1644982654131-79f434ac0c6c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60"),
              ),
              Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add_a_photo),
                  ))
            ],
          ),

          const SizedBox(height: 48),

          // email
          TextFieldInput(
              textEditingController: _emailController,
              hintText: "Enter your email",
              textInputType: TextInputType.emailAddress),

          const SizedBox(height: 24),

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
                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()) ),
                child: const Text(
                  " Login here",
                  style: TextStyle(color: blueColor),
                ),
              )
            ],
          ),
          Flexible(
            child: Container(),
            flex: 2,
          )
        ],
      ),
    )));
  }
}
