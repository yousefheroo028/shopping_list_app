import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shopping_list_app/core/contants.dart';
import 'package:shopping_list_app/features/groceries/model/grocery_item.dart';

part 'groceries_state.dart';

class GroceriesCubit extends HydratedCubit<GroceriesState> {
  GroceriesCubit() : super(const GroceriesInitial());

  Future<http.Response> addGroceryItem(GroceryItem groceryItem) async {
    emit(GroceriesLoading(state.groceryItems));
    final http.Response response = await http.post(
      Uri.https(firebaseBaseUrl, 'groceries.json'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(groceryItem.toJson()),
    );
    emit(GroceriesLoaded(<GroceryItem>[...state.groceryItems, groceryItem]));
    return response;
  }

  void removeGroceryItem(String groceryItemId) {
    emit(GroceriesLoading(state.groceryItems));
    emit(
      GroceriesLoaded(
        state.groceryItems
            .where((GroceryItem item) => item.id != groceryItemId)
            .toList(),
      ),
    );
  }

  @override
  GroceriesState? fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawList =
        (json['groceryItems'] as List<dynamic>? ?? const <dynamic>[]);
    final List<GroceryItem> items = rawList
        .map((e) => GroceryItem.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    return GroceriesLoaded(items);
  }

  @override
  Map<String, dynamic> toJson(GroceriesState state) {
    return <String, dynamic>{
      'groceryItems': state.groceryItems
          .map((GroceryItem e) => e.toJson())
          .toList(),
    };
  }
}
