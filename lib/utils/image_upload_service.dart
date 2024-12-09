import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart'; // Add this import

class ImageUploadService {
  static const String publicKey = "public_mrF+95BntrMir1p8a72kXyqGSrk="; // Replace with your ImageKit public key
  static const String privateKey = "private_hRgC0U+tExByrN7IDgPkGyu0OUg="; // Replace with your ImageKit private key
  static const String uploadEndpoint = "https://upload.imagekit.io/api/v1/files/upload";

  static void _log(String message, {Map<String, dynamic>? data}) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] ImageUpload: $message');
    if (data != null) {
      print('Data: ${data.toString()}');
    }
  }

  static Future<String> uploadImage(File imageFile) async {
    try {
      _log('Starting upload process', data: {
        'fileSize': await imageFile.length(),
        'filePath': imageFile.path,
      });

      final mimeType = lookupMimeType(imageFile.path);
      final request = http.MultipartRequest('POST', Uri.parse(uploadEndpoint))
        ..headers['Authorization'] = 'Basic ${base64Encode(utf8.encode('$privateKey:'))}'
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        ))
        ..fields['fileName'] = path.basename(imageFile.path);

      _log('Sending request', data: {
        'endpoint': uploadEndpoint,
        'fileName': path.basename(imageFile.path),
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      _log('Response received', data: {
        'statusCode': response.statusCode,
        'body': responseBody,
      });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseBody);
        if (jsonResponse['url'] != null) {
          final imageUrl = jsonResponse['url'];
          _log('Upload successful', data: {'imageUrl': imageUrl});
          return imageUrl;
        } else {
          throw Exception('Invalid response format from ImageKit');
        }
      } else if (response.statusCode == 403) {
        throw Exception('Upload failed with status 403: Your account cannot be authenticated. For support kindly contact us at support@imagekit.io');
      } else {
        throw Exception(
            'Upload failed with status ${response.statusCode}: $responseBody');
      }
    } catch (e) {
      _log('Error during upload', data: {'error': e.toString()});
      rethrow;
    }
  }

  static String getImageUrl(String imagePath) {
    // For ImageKit, just return the URL as is since it's already a direct image URL
    return imagePath;
  }
}
