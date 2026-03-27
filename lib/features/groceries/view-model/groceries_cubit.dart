import 'dart:convert';

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
    emit(GroceriesLoaded(state.groceryItems.where((GroceryItem item) => item.id != groceryItemId).toList()));
  }

  @override
  GroceriesState? fromJson(Map<String, dynamic> json) {
    return GroceriesLoaded(
      (json['groceryItems'] as List<dynamic>)
          .map((encodedItem) => GroceryItem.fromJson(encodedItem as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson(GroceriesState state) {
    return <String, dynamic>{
      'groceryItems': state.groceryItems.map((GroceryItem decodedItem) => decodedItem.toJson()).toList(),
    };
  }
}
