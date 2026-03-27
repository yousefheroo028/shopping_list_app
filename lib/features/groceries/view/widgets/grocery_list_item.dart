import 'package:flutter/material.dart';
import 'package:shopping_list_app/core/enums/categories.dart';
import 'package:shopping_list_app/features/groceries/model/grocery_item.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem({required this.item, super.key});

  final GroceryItem item;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: ColoredBox(color: categories[item.category]!.color, child: const SizedBox(height: 10, width: 10)),
    title: Text(item.name),
    trailing: Text('${item.quantity}'),
  );
}
