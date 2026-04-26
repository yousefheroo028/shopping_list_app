part of 'groceries_cubit.dart';

sealed class GroceriesState with EquatableMixin {
  final List<GroceryItem> groceryItems;

  const GroceriesState(this.groceryItems);

  @override
  List<Object?> get props => [groceryItems];
}

final class GroceriesInitial extends GroceriesState {
  GroceriesInitial() : super([]);
}

final class GroceriesLoading extends GroceriesState {
  GroceriesLoading(super.groceryItems);
}

final class GroceriesLoaded extends GroceriesState {
  GroceriesLoaded(super.groceryItems);
}

final class GroceriesError extends GroceriesState {
  GroceriesError(this.message) : super(<GroceryItem>[]);

  final String message;

  @override
  List<Object?> get props => [message];
}
