import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_app/features/groceries/view-model/groceries_cubit.dart';
import 'package:shopping_list_app/features/groceries/view/widgets/grocery_list_item.dart';

class GorceriesListWidget extends StatelessWidget {
  const GorceriesListWidget(this.state, {super.key});

  final GroceriesState state;

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: const .all(16.0),
    itemBuilder: (BuildContext context, int index) => Dismissible(
      key: ValueKey<String>(state.groceryItems[index].id!),
      direction: .horizontal,
      confirmDismiss: (DismissDirection direction) async => await showAdaptiveDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog.adaptive(
          title: const Text('Are you sure?'),
          content: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Text('ID: ${state.groceryItems[index].id}'),
              Text('Name: ${state.groceryItems[index].name}'),
              Text('Category: ${state.groceryItems[index].category.name}'),
              Text('Quantity: ${state.groceryItems[index].quantity}'),
            ],
          ),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('${state.groceryItems[index].name} dismissed')));
                context.read<GroceriesCubit>().removeGroceryItem(state.groceryItems[index].id!);
                state.groceryItems.removeAt(index);
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
      child: GroceryListItem(item: state.groceryItems[index]),
    ),
    itemCount: state.groceryItems.length,
    separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 16.0),
  );
}
