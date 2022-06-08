import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePiker extends StatefulWidget {


  UserImagePiker({Key? key, required this.pickUserImage, this.imgeUrl})
      : super(key: key);
  Function pickUserImage;
  final String? imgeUrl;

  @override
  State<UserImagePiker> createState() => _UserImagePikerState();
}

class _UserImagePikerState extends State<UserImagePiker> {
  @override
  final _piker = ImagePicker();

  XFile? image;

  Future<void> pickImage() async {
    image = await _piker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,


      imageQuality: 50,
      maxWidth: 720,
      maxHeight: 720,);
  }

  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          child: CircleAvatar(
            minRadius: 40,
            maxRadius: 45,
            backgroundImage:

            image != null ? FileImage(File(image!.path)) : null,
            child:widget.imgeUrl != null ? FittedBox(
              child: CircleAvatar(
                minRadius: 40,
                maxRadius: 45,
                backgroundImage: NetworkImage(widget.imgeUrl!),),
            ) : image == null
                ? SizedBox(
                height: 60,
                width: 60,
                child: Image.asset(
                  'assets/pngwing.PNG',
                  color: Colors.white60,
                ))
                : null,
          ),
        ),
        SizedBox(
          height: 35,
          width: 35,
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            onPressed: () async {
              await pickImage();
              widget.pickUserImage(image);
              setState(() {});
            },
            child: Icon(Icons.camera_alt),
          ),
        ),
      ],
    );
  }
}
