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
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration _timeout = Duration(seconds: 45);

  // Fetch all posts
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
          message: 'Kugeraho amakuru byanze. Ongera ugerageze.',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException(
          message: 'Nta interineti. Reba aho wandikiye maze ugerageze.');
    } on FormatException {
      throw ApiException(message: 'Amakuru yoherejwe si yo. Ongera ugerageze.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Ikosa ridategerejwe: $e');
    }
  }

  // Fetch single post
  Future<Post> fetchPost(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/posts/$id'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return Post.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw ApiException(
            message: 'Inyandiko ntiyabonetse.', statusCode: 404);
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
      throw ApiException(message: 'Ikosa ridategerejwe: $e');
    }
  }

  // Create a new post
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
          message: 'Gukora inyandiko nshya byanze.',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException(message: 'Nta interineti. Reba aho wandikiye.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Ikosa ridategerejwe: $e');
    }
  }

  // Update a post
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
          message: 'Guhindura inyandiko byanze.',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException(message: 'Nta interineti. Reba aho wandikiye.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Ikosa ridategerejwe: $e');
    }
  }

  // Delete a post
  Future<void> deletePost(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$_baseUrl/posts/$id'))
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw ApiException(
          message: 'Gusiba inyandiko byanze.',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException(message: 'Nta interineti. Reba aho wandikiye.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Ikosa ridategerejwe: $e');
    }
  }
}
