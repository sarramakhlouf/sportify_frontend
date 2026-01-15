import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TeamImagePicker extends StatelessWidget {
  final File? image;
  final Function(File) onPick;

  const TeamImagePicker({
    super.key,
    required this.image,
    required this.onPick,
  });

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) onPick(File(img.path));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          image: image != null
              ? DecorationImage(image: FileImage(image!), fit: BoxFit.cover)
              : null,
        ),
        child: image == null
            ? const Center(
                child: Icon(Icons.cloud_upload, size: 40),
              )
            : null,
      ),
    );
  }
}
