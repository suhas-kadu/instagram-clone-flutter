import 'package:flutter/material.dart';
import "package:flutter_svg/svg.dart";
import 'package:instagram_clone_flutter/resources/user_auth.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:instagram_clone_flutter/views/signup_screen.dart';
import 'package:instagram_clone_flutter/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res != "success") {
      showSnackBar(context, res);
    }

    setState(() {
      _isLoading = false;
    });

    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: _isLoading ? const Center(child: CircularProgressIndicator()) : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(flex: 2, child: Container()),
          // instagram logo
          SvgPicture.asset(
            "assets/images/instagram_logo.svg",
            color: primaryColor,
            height: 64,
          ),

          const SizedBox(height: 64),

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
            onTap: (){
              loginUser();
            },
            child: Container(
              child: const Text("Login"),
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
              const Text("Don't have an account ?"),
              GestureDetector(
                onTap: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignupScreen())),
                child: const Text(
                  " Create here",
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
