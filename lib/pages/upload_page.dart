import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reon_machine_test/defaults/dimensions.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  List<File> _selectedImages = [];

  Future<void> _uploadImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _selectedImages.add(imageFile);
      });
    }
  }

  Future<void> _uploadSelectedImages(BuildContext context) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/images');
    if (!await imagesDir.exists()) {
      imagesDir.createSync(recursive: true);
    }

    for (final selectedImage in _selectedImages) {
      final fileName = path.basename(selectedImage.path);
      final savedImage = await selectedImage.copy('${imagesDir.path}/$fileName');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Images uploaded successfully'),
      ),
    );

    setState(() {
      _selectedImages.clear();
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Upload Image', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                  top: Dimensions.toppadiing18,
                  right: Dimensions.leftpadiing13,
                  left: Dimensions.leftpadiing13,
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[200], ),

                      child: IconButton(
                        icon: Icon(Icons.camera_alt,size: 55),
                        onPressed: () => _uploadImage(ImageSource.camera),
                      ),
                    ),
                    ..._selectedImages.map(
                          (image) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.file(
                            image,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ).toList(),
                    GestureDetector(
                      onTap: () => _uploadImage(ImageSource.gallery),
                      child: Container(
                        color: Colors.white,
                        child: Icon(Icons.add,size: 55),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          left: Dimensions.leftpadiing35,
          right: Dimensions.rightpadiing15,
          bottom: Dimensions.bottempadiing8,
        ),
        child: Container(
          width: double.maxFinite,
          height: Dimensions.height45,
          child: FloatingActionButton(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
            onPressed: _selectedImages.isEmpty
                ? null
                : () {
              _uploadSelectedImages(context);
            },
            child: Text("Upload"),
          ),
        ),
      ),
    );
  }
}
