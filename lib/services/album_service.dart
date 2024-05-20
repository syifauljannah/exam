import 'dart:convert';

import 'package:exam2/models/album.dart';
import 'package:http/http.dart' as http;

class AlbumService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/photos';
  static Future<List<Album>> fetchAlbums() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> result = jsonDecode(response.body);

        List<Album> albums =
            result.map((albumjson) => Album.fromJson(albumjson)).toList();

        return albums;
      } else {
        throw Exception('failed to load user');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> deleteAlbum(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Gagal Untuk Menghapus Album');
    }
  }

  static Future<void> updateAlbum(Album album) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${album.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(album.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal Untuk Mengedit Album');
    }
  }
}
