import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:instagram_clone_flutter/resources/firestore_methods.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:instagram_clone_flutter/models/user.dart' as model;
import 'package:provider/provider.dart';

class AddAPostScreen extends StatefulWidget {
  @override
  State<AddAPostScreen> createState() => _AddAPostScreenState();
}

class _AddAPostScreenState extends State<AddAPostScreen> {
  Uint8List? _file;
  TextEditingController _descriptionController = TextEditingController();
  bool isPostUploaded = false;

  _selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a Post"),
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
                child: const Text("Take a Photo"),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
                child: const Text("Pick from Gallery"),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  postImage(
    String uid,
    String username,
    String profileImage,
  ) async {
    try {
      setState(() {
        isPostUploaded = true;
      });

      String res = await FireStoreMethods().uploadPost(
          uid, username, profileImage, _file!, _descriptionController.text);

      if (res == "success") {
        showSnackBar(context, "Post Uploaded Successfully!");
        clearImage();
        setState(() {
          isPostUploaded = false;
        });
      } else {
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Scaffold(
            body: Center(
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.upload),
                onPressed: () {
                  _selectImage(context);
                },
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                padding: const EdgeInsets.all(16.0),
                icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                onPressed: clearImage,
              ),
              title: const Text("New Post"),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: IconButton(
                      onPressed: () =>
                          postImage(user.uid, user.username, user.photoUrl),
                      icon: const FaIcon(
                        FontAwesomeIcons.check,
                        color: blueColor,
                      )),
                )
              ],
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  isPostUploaded
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: const LinearProgressIndicator(),
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 75,
                        width: 75,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                            )),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 135,
                        height: 75,
                        child: TextField(
                          controller: _descriptionController,
                          decoration:
                              InputDecoration(hintText: "Add a caption"),
                          maxLines: 8,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
