import 'package:flutter/material.dart';
import 'package:shopping_list_app/core/enums/categories.dart';
import 'package:shopping_list_app/features/groceries/model/grocery_item.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem({required this.item, super.key});

  final GroceryItem item;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      ColoredBox(color: categories[item.category]!.color, child: const SizedBox(height: 16.0, width: 16.0)),
      const SizedBox(width: 16.0),
      Text(item.name),
      const Spacer(),
      Text('${item.quantity}'),
    ],
  );
}
