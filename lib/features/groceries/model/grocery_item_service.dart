import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopping_list_app/core/constants.dart';
import 'package:shopping_list_app/features/groceries/model/grocery_item.dart';

class GroceryItemService {
  static Future<http.Response> fetchData() async {
    final http.Response response = await http.get(
      Uri.https(Constants.firebaseBaseUrl, 'groceries.json'),
      headers: <String, String>{'Content-Type': 'application/json'},
    );
    return response;
  }

  static Future<http.Response> postData(GroceryItem item) async {
    final http.Response response = await http.post(
      Uri.https(Constants.firebaseBaseUrl, 'groceries.json'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(item.toJson()),
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to post data');
    }
  }

  static void deleteData(String groceryItemId) {
    http.delete(
      Uri.https(Constants.firebaseBaseUrl, 'groceries/$groceryItemId.json'),
    );
  }
}
