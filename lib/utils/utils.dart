import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

pickImage(ImageSource imageSource) async {
  final _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: imageSource);

  if (_file != null) {
    return await _file.readAsBytes();
  }

  print("No image selected");
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

void launchUrl(String url) async {
  if (!await launch(url)) throw "Could not launch $url";
}

Widget loadNetworkImage(
    BuildContext context, String imgUrl, String placeHolderText,
    [double? width, double? height]) {
  return CachedNetworkImage(
    imageUrl: imgUrl,
    placeholder: (context, placeHolderText) =>
        const Center(child: CircularProgressIndicator()),
    errorWidget: (context, imgUrl, error) {
      return showSnackBar(context, error.toString());
    },
    // Curve fadeOutCurve = Curves.easeOut,
    // Duration fadeInDuration = const Duration(milliseconds: 500),
    // Curve fadeInCurve = Curves.easeIn,
    // height: height,
    // width: width,
  );
}
