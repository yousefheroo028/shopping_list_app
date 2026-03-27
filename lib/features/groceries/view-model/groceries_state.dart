part of 'groceries_cubit.dart';

sealed class GroceriesState {
  final List<GroceryItem> groceryItems;

  const GroceriesState(this.groceryItems);
}

final class GroceriesInitial extends GroceriesState {
  const GroceriesInitial() : super(const <GroceryItem>[]);
}

final class GroceriesLoading extends GroceriesState {
  const GroceriesLoading(super.groceryItems);
}

final class GroceriesLoaded extends GroceriesState {
  const GroceriesLoaded(super.groceryItems);
}
