
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageCompressor {
  /// Compress image and return File (compatible with existing code)
  static Future<File?> compressFile(File imageFile, {int quality = 60}) async {
    try {
      final dir = await getTemporaryDirectory();
      final originalExtension = path.extension(imageFile.path).toLowerCase();

      // Determine format based on original file extension
      CompressFormat format;
      String extension;

      switch (originalExtension) {
        case '.jpg':
        case '.jpeg':
          format = CompressFormat.jpeg;
          extension = '.jpg';
          break;
        case '.png':
          format = CompressFormat.png;
          extension = '.png';
          break;
        case '.webp':
          format = CompressFormat.webp;
          extension = '.webp';
          break;
        case '.heic':
          format = CompressFormat.heic;
          extension = '.heic';
          break;
        default:
          format = CompressFormat.jpeg;
          extension = '.jpg';
      }

      final targetPath = path.join(
        dir.path,
        "${DateTime.now().millisecondsSinceEpoch}$extension",
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        imageFile.path,
        targetPath,
        quality: quality,
        format: format,
      );

      if (result != null) {
        return File(result.path);
      }
      return null;
    } catch (e) {
      print("Compression error: $e");
      return null;
    }
  }

  /// Compress to WebP format specifically
  static Future<File?> compressToWebP(File imageFile, {int quality = 60}) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        "${DateTime.now().millisecondsSinceEpoch}.webp",
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        imageFile.path,
        targetPath,
        quality: quality,
        format: CompressFormat.webp,
      );

      if (result != null) {
        return File(result.path);
      }
      return null;
    } catch (e) {
      print("WebP compression error: $e");
      return null;
    }
  }
}