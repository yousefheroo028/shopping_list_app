import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shopping_list_app/core/constants.dart';
import 'package:shopping_list_app/features/groceries/model/grocery_item.dart';
import 'package:shopping_list_app/features/groceries/model/grocery_item_repo.dart';
import 'package:shopping_list_app/features/groceries/model/grocery_item_service.dart';

part 'groceries_state.dart';

class GroceriesCubit extends HydratedCubit<GroceriesState> {
  final GroceryItemRepo repo = GroceryItemRepo();

  GroceriesCubit() : super(const GroceriesInitial(<GroceryItem>[])) {
    emit(GroceriesLoading(state.groceryItems));
    try {
      repo.getGroceryItems().then((List<GroceryItem>? value) {
        if (value == null) {
          emit(GroceriesError('There is an error.'));
          return;
        }
        emit(GroceriesLoaded(value));
      });
    } catch (e) {
      emit(GroceriesError(e.toString()));
    }
  }

  Future<void> refresh() async {
    emit(GroceriesLoading(state.groceryItems));
    try {
      repo.getGroceryItems().then((List<GroceryItem>? value) {
        if (value == null) {
          emit(GroceriesError('There is an error.'));
          return;
        }
        emit(GroceriesLoaded(value));
      });
    } catch (e) {
      emit(GroceriesError(e.toString()));
    }
  }

  Future<http.Response> addGroceryItem(GroceryItem groceryItem) async {
    final http.Response response = await GroceryItemService.postData(groceryItem);
    final String id = json.decode(response.body)['name'];
    emit(GroceriesLoaded(<GroceryItem>[...state.groceryItems, groceryItem.copyWith(id: id)]));
    return response;
  }

  void removeGroceryItem(String groceryItemId) {
    emit(GroceriesLoaded(state.groceryItems.where((GroceryItem item) => item.id != groceryItemId).toList()));
    http.delete(
      Uri.https(Constants.firebaseBaseUrl, 'groceries/$groceryItemId.json'),
    );
  }

  @override
  GroceriesState? fromJson(Map<String, dynamic> json) {
    return GroceriesLoaded(
      (json['groceryItems'] as List<dynamic>).map((dynamic encodedItem) => GroceryItem.fromJson(encodedItem)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson(GroceriesState state) {
    return <String, dynamic>{
      'groceryItems': state.groceryItems.map((GroceryItem decodedItem) => decodedItem.toJson()).toList(),
    };
  }
}
