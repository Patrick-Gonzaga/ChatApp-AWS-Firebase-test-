import 'dart:io';

import 'package:comms/secrets.dart';
import 'package:http/http.dart' as http;

class AWSS3Service {
  static const _accessKey = Secrets.awsAccessKey;
  static const _secretAccessKey = Secrets.awsSecretKey;
  static const _bucketName = 'comms-app-db';
  static const _region = 'us-east-1';

  static Future<String?> uploadImage(File imgFile) async {
    try {
      final String fileName =
          'images/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';

      final url = 'https://$_bucketName.s3.$_region.amazonaws.com/$fileName';

      final imageBytes = await imgFile.readAsBytes();

      final response = await http.put(
        Uri.parse(url),
        body: imageBytes,
        headers: {'Content-Type': 'image/jpeg'},
      );

      if (response.statusCode == 200) {
        print("upload concluído! URL:$url");
        return url;
      } else {
        print('Erro: ${response.statusCode} // ${response.body}');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
