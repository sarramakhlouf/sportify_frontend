import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sportify_frontend/core/constants/api_constants.dart';

class ProfilePhotoPicker extends StatefulWidget {
  final String? imageUrl;
  final Function(File?) onImageSelected;
  final String baseUrl = ApiConstants.baseUrl;

  const ProfilePhotoPicker({
    super.key,
    required this.onImageSelected,
    this.imageUrl,
  });

  @override
  State<ProfilePhotoPicker> createState() => _ProfilePhotoPickerState();
}

class _ProfilePhotoPickerState extends State<ProfilePhotoPicker> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      widget.onImageSelected(_selectedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;

    if (_selectedImage != null) {
      imageProvider = FileImage(_selectedImage!);
    } else if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      final String fullUrl = widget.imageUrl!.startsWith('http')
          ? widget.imageUrl!
          : "${widget.baseUrl}${widget.imageUrl}"; 

      imageProvider = NetworkImage(fullUrl);
    }


    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: imageProvider,
          child: imageProvider == null
              ? const Icon(Icons.person, size: 40, color: Colors.grey)
              : null,
        ),

        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
  
}
