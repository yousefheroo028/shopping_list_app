import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_app/features/groceries/model/grocery_item.dart';
import 'package:shopping_list_app/features/add_groceries/view/add_grocery_item_page.dart';
import 'package:shopping_list_app/features/groceries/view-model/groceries_cubit.dart';
import 'package:shopping_list_app/features/groceries/view/widgets/grocery_list_item.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GroceriesCubit groceriesCubit = context.read<GroceriesCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: <Widget>[
          IconButton(
            onPressed: () => showModalBottomSheet<GroceryItem>(
              context: context,
              isScrollControlled: true,
              constraints: BoxConstraints(minHeight: MediaQuery.heightOf(context) / 2),
              builder: (_) => BlocProvider<GroceriesCubit>.value(
                value: groceriesCubit,
                child: const AddGroceryItemBottomSheet(),
              ),
              showDragHandle: true,
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<GroceriesCubit, GroceriesState>(
        builder: (BuildContext context, GroceriesState state) => Center(
          child: switch (state) {
            GroceriesInitial() => const Text('There is no Groceries'),
            GroceriesLoading() => const RepaintBoundary(child: CircularProgressIndicator.adaptive()),
            GroceriesLoaded() =>
              state.groceryItems.isEmpty
                  ? const Text('There is no Groceries')
                  : RefreshIndicator.adaptive(
                      onRefresh: () => groceriesCubit.refresh(),
                      child: ListView.separated(
                        padding: const .all(16.0),
                        itemBuilder: (BuildContext context, int index) => Dismissible(
                          key: ValueKey<String>(state.groceryItems[index].id!),
                          direction: .horizontal,
                          confirmDismiss: (DismissDirection direction) async =>
                              await showAdaptiveDialog<bool>(
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
                                        groceriesCubit.removeGroceryItem(state.groceryItems[index].id!);
                                        state.groceryItems.removeAt(index);
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              ) ??
                              null,
                          child: GroceryListItem(item: state.groceryItems[index]),
                        ),
                        itemCount: state.groceryItems.length,
                        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 16.0),
                      ),
                    ),
            GroceriesError(:final String message) => Text(message),
          },
        ),
      ),
    );
  }
}
