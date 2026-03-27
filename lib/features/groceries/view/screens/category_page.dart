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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: <Widget>[
          IconButton(
            onPressed: () => showModalBottomSheet<GroceryItem>(
              context: context,
              builder: (_) => SizedBox(
                height: MediaQuery.heightOf(context) / 2,
                child: BlocProvider<GroceriesCubit>.value(
                  value: groceriesCubit,
                  child: const AddGroceryItemBottomSheet(),
                ),
              ),
              showDragHandle: true,
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<GroceriesCubit, GroceriesState>(
        builder: (BuildContext context, GroceriesState state) => switch (state) {
          GroceriesInitial() => const Center(child: Text('There is no Groceries')),
          GroceriesLoading() => const Center(child: CircularProgressIndicator.adaptive()),
          GroceriesLoaded() =>
            state.groceryItems.isEmpty
                ? const Center(child: Text('There is no Groceries'))
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) => Dismissible(
                      key: ValueKey<String>(state.groceryItems[index].id),
                      direction: .horizontal,
                      onDismissed: (DismissDirection direction) {
                        groceriesCubit.removeGroceryItem(state.groceryItems[index].id);
                        state.groceryItems.removeAt(index);
                      },
                      child: GroceryListItem(item: state.groceryItems[index]),
                    ),
                    itemCount: state.groceryItems.length,
                  ),
        },
      ),
    );
  }
}
