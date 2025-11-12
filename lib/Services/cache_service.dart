import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CacheService {

  static Future<String> loadTextFromUrlWithCache(String itemDownloadUrl, String itemId) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$itemId.txt');

    if (await file.exists()) {
      return await file.readAsString();
    }

    final response = await http.get(Uri.parse(itemDownloadUrl));
    final text = response.body;

    await file.writeAsString(text); 
    return text;
  }

}