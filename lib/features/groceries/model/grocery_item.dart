import 'package:shopping_list_app/core/enums/categories.dart';

class GroceryItem {
  final String id;
  final String name;
  final int quantity;
  final CategoryEnum category;

  const GroceryItem({required this.id, required this.name, required this.quantity, required this.category});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'quantity': quantity,
      'category': category.name,
    };
  }

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      category: CategoryEnum.values.byName(json['category'] as String),
    );
  }
}
