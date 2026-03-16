import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class PostService {
  static const String _baseUrl = 'http://jsonplaceholder.typicode.com';
  static const Duration _timeout = Duration(seconds: 60);

  // Fallback sample posts if internet is not available
  static List<Post> get fallbackPosts => [
    Post(id: 1, userId: 1, title: 'Ikaze kuri Posts Manager', body: 'Murakaza neza kuri Posts Manager App. Interineti ntabwo ihari ubu, ariko urashobora kongeramo inyandiko nshya.'),
    Post(id: 2, userId: 1, title: 'Uburyo bwo gukoresha app', body: 'Kanda Post nshya hasi iburyo kugirango wongeremo inyandiko. Urashobora no guhindura cyangwa gusiba inyandiko iyo ubishaka.'),
    Post(id: 3, userId: 2, title: 'Amakuru y\'u Rwanda', body: 'U Rwanda ni igihugu gikura vuba cyane muri Afurika. Ikoranabuhanga ryageze kure mu myaka ya vuba.'),
    Post(id: 4, userId: 2, title: 'Ikoranabuhanga mu Rwanda', body: 'Rwanda Rwageze kure cyane mu ikoranabuhanga. Kigali ni umwe mu mijyi inoze cyane muri Afurika.'),
    Post(id: 5, userId: 3, title: 'Flutter ni iki?', body: 'Flutter ni framework ya Google yo gukora apps kuri Android na iOS icyarimwe. Ikoresha ururimi rwa Dart.'),
  ];

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/posts'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Post.fromJson(json)).toList();
      } else {
        throw ApiException(
          message: 'Kubona Posts byanze. Ongera ugerageze.',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      // Return sample posts when no internet
      return fallbackPosts;
    } catch (e) {
      if (e is ApiException) rethrow;
      // Return sample posts on timeout or any other error
      return fallbackPosts;
    }
  }

  Future<Post> fetchPost(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/posts/$id'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return Post.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw ApiException(message: 'Post ntiyabonetse.', statusCode: 404);
      } else {
        throw ApiException(
          message: 'Kugeraho inyandiko byanze.',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException(message: 'Nta interineti. Reba aho wandikiye.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Ikosa ritategenajwe: $e');
    }
  }

  Future<Post> createPost(Post post) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/posts'),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode(post.toJson()),
          )
          .timeout(_timeout);

      if (response.statusCode == 201) {
        return Post.fromJson(jsonDecode(response.body));
      } else {
        throw ApiException(
          message: 'Gukora Post nshya byanze.',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException(message: 'Nta interineti. Mugerageze Mukanya.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Ikosa ritateganijwe: $e');
    }
  }

  Future<Post> updatePost(Post post) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_baseUrl/posts/${post.id}'),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode(post.toJson()),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return Post.fromJson(jsonDecode(response.body));
      } else {
        throw ApiException(
          message: 'Guhindura Post byanze.',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException(message: 'Nta interineti. Mugerageze mukanya.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Ikosa ritateganijwe: $e');
    }
  }

  Future<void> deletePost(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$_baseUrl/posts/$id'))
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw ApiException(
          message: 'Gusiba Post byanze.',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException(message: 'Nta interineti. Mugerageze Mukanya.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Ikosa ritateganijwe: $e');
    }
  }
}