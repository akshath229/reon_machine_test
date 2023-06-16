import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:reon_machine_test/defaults/dimensions.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<File> _images = [];
  List<bool> _selectedImages = [];
  bool _isEditing = false;
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/images');
    if (await imagesDir.exists()) {
      final files = imagesDir.listSync();
      final sortedFiles = _sortFilesByCreationTime(files);
      setState(() {
        _images = sortedFiles.map((file) => File(file.path)).toList();
        _selectedImages = List.generate(_images.length, (_) => false);
      });
    }
  }

  List<FileSystemEntity> _sortFilesByCreationTime(List<FileSystemEntity> files) {
    files.sort((a, b) => File(a.path).lastModifiedSync().compareTo(File(b.path).lastModifiedSync()));
    return files;
  }

  Future<void> _deleteSelectedImages() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          child: Container(
            width: double.maxFinite,
            height: Dimensions.height150,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Are you sure you want to',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'delete this image?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Dimensions.height16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: Dimensions.width90,
                            height: Dimensions.height40,
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            List<File> deletedImages = [];
                            for (int i = _selectedImages.length - 1; i >= 0; i--) {
                              if (_selectedImages[i]) {
                                deletedImages.add(_images[i]);
                                _images[i].deleteSync();
                                _images.removeAt(i);
                                _selectedImages.removeAt(i);
                              }
                            }
                            Navigator.of(context).pop();
                            _showDeletedSnackbar(deletedImages);
                            setState(() {
                              _isEditing = false;
                            });
                          },
                          child: Container(
                            width: Dimensions.width90,
                            height: Dimensions.height40,
                            child: Center(
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeletedSnackbar(List<File> deletedImages) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deletedImages.length} image(s) deleted'),
      ),
    );
  }

  Future<void> _uploadImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/images');
      if (!await imagesDir.exists()) {
        imagesDir.createSync(recursive: true);
      }
      final imageFile = File(pickedFile.path);
      final imageName = path.basename(imageFile.path);
      final imagePath = '${imagesDir.path}/$imageName';
      imageFile.copySync(imagePath);
      setState(() {
        _images.add(File(imagePath));
        _selectedImages.add(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10, top: 15),
        child: Column(
          children: [
            SizedBox(height: Dimensions.height20),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('lib/images/profilephoto.png'),
                ),
                SizedBox(width: Dimensions.width20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back  👋',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Edwin Joseph',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 12.0,
                ),
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  final image = _images[index];
                  return GestureDetector(
                    onTap: () {
                      if (_isEditing) {
                        setState(() {
                          _selectedImages[index] = !_selectedImages[index];
                        });
                      }
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.file(
                            image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (_isEditing)
                          Positioned(
                            top: -10,
                            right: 12,
                            child: Checkbox(
                              activeColor: Colors.black,
                              checkColor: Colors.white,
                              value: _selectedImages[index],
                              onChanged: (value) {
                                setState(() {
                                  _selectedImages[index] = value!;
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isEditing
          ? _selectedImages.contains(true)
          ? Container(
        width: Dimensions.width130,
        height: Dimensions.height40,
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: _deleteSelectedImages,
          child: Text("Delete"),
        ),
      )
          : Container(
        width: Dimensions.width130,
        height: Dimensions.height40,
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () {
            setState(() {
              _selectAll = !_selectAll;
              for (int i = 0; i < _selectedImages.length; i++) {
                _selectedImages[i] = _selectAll;
              }
            });
          },
          child: Text("Select All"),
        ),
      )
          : Container(
        width: Dimensions.width130,
        height: Dimensions.height40,
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mode_edit_outline_sharp),
              Text('Edit'),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
