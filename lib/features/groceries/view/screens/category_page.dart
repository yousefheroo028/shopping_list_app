import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              constraints: BoxConstraints(minHeight: MediaQuery.heightOf(context) / 2),
              builder: (_) => const AddGroceryItemBottomSheet(),
              showDragHandle: true,
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<GroceriesCubit, GroceriesState>(
        builder: (_, GroceriesState state) {
          if (kDebugMode) {
            print('Rebuilt at state $state');
          }
          return RefreshIndicator.adaptive(
            onRefresh: () => groceriesCubit.refresh(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Center(
                  child: switch (state) {
                    GroceriesInitial() => const EmptyStateWidget(),
                    GroceriesLoading() => const RepaintBoundary(child: CircularProgressIndicator.adaptive()),
                    GroceriesLoaded() => state.groceryItems.isEmpty ? const EmptyStateWidget() : GorceriesListWidget(state),
                    GroceriesError(:final String message) => Text(message),
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.heightOf(context) - MediaQuery.paddingOf(context).top - kToolbarHeight,
      child: const Text('There is no Groceries'),
    );
  }
}
