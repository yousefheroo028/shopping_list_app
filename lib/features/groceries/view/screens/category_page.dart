import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_app/features/groceries/model/grocery_item.dart';
import 'package:shopping_list_app/features/add_groceries/view/add_grocery_item_page.dart';
import 'package:shopping_list_app/features/groceries/view-model/groceries_cubit.dart';
import 'package:shopping_list_app/features/groceries/view/widgets/groceries_list_widget.dart';

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
                      child: GorceriesListWidget(state),
                    ),
            GroceriesError(:final String message) => Text(message),
          },
        ),
      ),
    );
  }
}
