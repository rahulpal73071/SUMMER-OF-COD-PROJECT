import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../models/product_model.dart';

class ProductService {
  final String baseUrl = 'http://10.21.145.117:5000/api/products';

  Future<List<Product>> fetchProducts({String? category, String? search}) async {
    String url = baseUrl;
    final Map<String, String> queryParams = {};

    if (category != null) queryParams['category'] = category;
    if (search != null) queryParams['search'] = search;

    if (queryParams.isNotEmpty) {
      url += '?${Uri(queryParameters: queryParams).query}';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<void> createProduct({
    required String title,
    required String description,
    required double price,
    required int quantity,
    required String category,
    required List<File> images,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final uri = Uri.parse(baseUrl);
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();
    request.fields['quantity'] = quantity.toString();
    request.fields['category'] = category;

    for (File image in images) {
      final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
      final parts = mimeType.split('/');
      request.files.add(await http.MultipartFile.fromPath(
        'images',
        image.path,
        contentType: MediaType(parts[0], parts[1]),
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 201) {
      throw Exception('Failed to create product: ${response.body}');
    }
  }

  Future<void> deleteProduct(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }

  Future<void> updateProduct({
    required String id,
    required String title,
    required String description,
    required double price,
    required int quantity,
    required String category,
    required List<File> newImages,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final uri = Uri.parse('$baseUrl/$id');
    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();
    request.fields['quantity'] = quantity.toString();
    request.fields['category'] = category;

    for (File image in newImages) {
      final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
      final parts = mimeType.split('/');
      request.files.add(await http.MultipartFile.fromPath(
        'images',
        image.path,
        contentType: MediaType(parts[0], parts[1]),
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('Failed to update product: ${response.body}');
    }
  }
}
