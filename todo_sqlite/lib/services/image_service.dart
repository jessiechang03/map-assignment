import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ImageService {
  static final ImageService instance = ImageService._init();
  ImageService._init();

  final ImagePicker _picker = ImagePicker();

  Future<String?> pickAndSaveImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        return await _saveImageToAppDirectory(File(pickedFile.path));
      }
    } catch (e) {
      print('Error picking image: $e');
    }
    return null;
  }

  Future<String?> captureAndSaveImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        return await _saveImageToAppDirectory(File(pickedFile.path));
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
    return null;
  }

  Future<String> _saveImageToAppDirectory(File imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/todo_images');
    
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
    final savedImage = await imageFile.copy('${imagesDir.path}/$fileName');
    
    return savedImage.path;
  }

  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  bool imageExists(String imagePath) {
    return File(imagePath).existsSync();
  }
}