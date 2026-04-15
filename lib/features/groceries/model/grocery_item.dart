import 'package:equatable/equatable.dart';
import 'package:shopping_list_app/core/enums/categories.dart';

class GroceryItem with EquatableMixin {
  final String? id;
  final String name;
  final int quantity;
  final CategoryEnum category;

  const GroceryItem({this.id, required this.name, required this.quantity, required this.category});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'quantity': quantity,
      'category': category.name,
    };
  }

  factory GroceryItem.fromJson(MapEntry<String, dynamic> json) {
    return GroceryItem(
      id: json.key,
      name: json.value['name'] as String,
      quantity: json.value['quantity'] as int,
      category: CategoryEnum.values.byName(json.value['category'] as String),
    );
  }

  GroceryItem copyWith({
    String? id,
    String? name,
    int? quantity,
    CategoryEnum? category,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [id];
}
