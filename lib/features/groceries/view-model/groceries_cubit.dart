import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shopping_list_app/features/groceries/model/grocery_item.dart';
import 'package:shopping_list_app/features/groceries/model/grocery_item_repo.dart';
import 'package:shopping_list_app/features/groceries/model/grocery_item_service.dart';

part 'groceries_state.dart';

class GroceriesCubit extends HydratedCubit<GroceriesState> {
  final GroceryItemRepo repo;

  GroceriesCubit(this.repo) : super(GroceriesInitial());

  Future<void> refresh() async {
    emit(GroceriesLoading(state.groceryItems));
    await repo
        .getGroceryItems()
        .then((List<GroceryItem>? value) {
          emit(GroceriesLoaded(value ?? []));
        })
        .onError((error, stackTrace) {
          emit(GroceriesError(error.toString()));
        });
  }

  Future<http.Response> addGroceryItem(GroceryItem groceryItem) async {
    final http.Response response = await GroceryItemService.postData(groceryItem);
    final String id = json.decode(response.body)['name'];
    emit(GroceriesLoaded(<GroceryItem>[...state.groceryItems, groceryItem.copyWith(id: id)]));
    return response;
  }

  void removeGroceryItem(String groceryItemId) {
    emit(GroceriesLoaded(state.groceryItems.where((GroceryItem item) => item.id != groceryItemId).toList()));
    GroceryItemService.deleteData(groceryItemId);
  }

  @override
  GroceriesState? fromJson(Map<String, dynamic> json) {
    final rawList = json['groceryItems'] as List;
    final items = rawList.map((e) => GroceryItem.fromJson(e)).toList();
    return GroceriesLoaded(items);
  }

  @override
  Map<String, dynamic> toJson(GroceriesState state) {
    return <String, dynamic>{
      'groceryItems': state.groceryItems.map((GroceryItem decodedItem) => decodedItem.toJson()).toList(),
    };
  }
}
