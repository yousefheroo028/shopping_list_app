import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopping_list_app/features/groceries/model/grocery_item.dart';
import 'package:shopping_list_app/features/groceries/model/grocery_item_service.dart';

class GroceryItemRepo {
  GroceryItemRepo._internal();

  static final GroceryItemRepo _instance = GroceryItemRepo._internal();

  factory GroceryItemRepo() => _instance;

  Future<List<GroceryItem>?> getGroceryItems() async {
    final http.Response items = await GroceryItemService.fetchData();
    if (items.statusCode == 200) {
      if (items.body == 'null') return <GroceryItem>[];
      final List<GroceryItem> groceryItems = <GroceryItem>[];
      final Map<String, dynamic> body = json.decode(items.body);
      for (final MapEntry<String, dynamic> item in body.entries) {
        groceryItems.add(GroceryItem.fromJson(item));
      }
      return groceryItems;
    }
    return null;
  }
}
