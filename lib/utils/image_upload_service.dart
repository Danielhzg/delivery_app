import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class ImageUploadService {
  static const String apiKey =
      "5df09d03a3bc47f29c3f9536c762d92b"; // Replace with your ImgBB API key
  static const String uploadEndpoint = "https://api.imgbb.com/1/upload";

  static void _log(String message, {Map<String, dynamic>? data}) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] ImageUpload: $message');
    if (data != null) {
      print('Data: ${json.encode(data, toEncodable: (object) {
        if (object is File) return object.path;
        return object.toString();
      })}');
    }
  }

  static Future<String> uploadImage(File imageFile) async {
    try {
      _log('Starting upload process', data: {
        'fileSize': await imageFile.length(),
        'filePath': imageFile.path,
      });

      // Read file as bytes and encode to base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Create request body
      final fields = {
        'key': apiKey,
        'image': base64Image,
        'name': path.basename(imageFile.path),
      };

      _log('Sending request', data: {
        'endpoint': uploadEndpoint,
        'imageSize': bytes.length,
      });

      // Send POST request
      final response = await http.post(
        Uri.parse(uploadEndpoint),
        body: fields,
      );

      _log('Response received', data: {
        'statusCode': response.statusCode,
        'body': response.body,
      });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          // Use display_url instead of url for direct image access
          final imageUrl = jsonResponse['data']['display_url'];
          _log('Upload successful', data: {'imageUrl': imageUrl});
          return imageUrl;
        } else {
          throw Exception('Invalid response format from ImgBB');
        }
      } else {
        throw Exception(
            'Upload failed with status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      _log('Error during upload', data: {'error': e.toString()});
      rethrow;
    }
  }

  static String getImageUrl(String imagePath) {
    // For ImgBB, just return the URL as is since it's already a direct image URL
    return imagePath;
  }
}
