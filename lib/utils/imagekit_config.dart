import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ImageKitConfig {
  static const String publicKey = "public_mrF+95BntrMir1p8a72kXyqGSrk=";
  static const String privateKey = "private_hRgC0U+tExByrN7IDgPkGyu0OUg=";
  static const String urlEndpoint = "https://ik.imagekit.io/p0q6k0sws";
  static const String mediaLibraryEndpoint = "https://api.imagekit.io/v1/files";

  static String getImageUrl(String imagePath, {Map<String, dynamic>? transformations}) {
    if (imagePath.startsWith('http')) {
      return imagePath; // Return as-is if it's already a full URL
    }
    
    final endpoint = urlEndpoint.endsWith('/') ? urlEndpoint : '$urlEndpoint/';
    
    // Create transformation string if transformations are provided
    final transformString = transformations?.entries
        .map((e) => '${e.key}-${e.value}')
        .join(',');

    // Add transformations to URL if present
    if (transformString != null && transformString.isNotEmpty) {
      return '$endpoint/tr:$transformString/$imagePath';
    }
    
    return '$endpoint/$imagePath';
  }

  static Future<Map<String, dynamic>> getAuthParams() async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Current time in seconds
    final expire = now + 3600; // 1 hour from now

    // Generate signature using private key and expiry
    final rawSignature = '$privateKey$expire';
    final signature = sha1.convert(utf8.encode(rawSignature)).toString();

    return {
      'expire': expire,
      'signature': signature,
    };
  }

  static Future<String> uploadImage(String filePath, String fileName) async {
    try {
      final authParams = await getAuthParams();
      final url = Uri.parse('$mediaLibraryEndpoint/upload');
      final request = http.MultipartRequest('POST', url);

      // Add authentication parameters
      request.fields['publicKey'] = publicKey;
      request.fields['signature'] = authParams['signature'];
      request.fields['expire'] = authParams['expire'].toString();
      request.fields['fileName'] = fileName;
      request.fields['folder'] = '/menu';

      // Add the file
      final bytes = await File(filePath).readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);

      // Send the request
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        return jsonResponse['url'];
      } else {
        throw Exception('Failed to upload image: ${jsonResponse['message']}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}