part of 'groceries_cubit.dart';

sealed class GroceriesState with EquatableMixin {
  final List<GroceryItem> groceryItems;

  const GroceriesState(this.groceryItems);
}

final class GroceriesInitial extends GroceriesState {
  const GroceriesInitial(super.groceryItems);

  @override
  List<Object?> get props => <Object?>[];
}

final class GroceriesLoading extends GroceriesState {
  const GroceriesLoading(super.groceryItems);

  @override
  List<Object?> get props => super.groceryItems;
}

final class GroceriesLoaded extends GroceriesState {
  const GroceriesLoaded(super.groceryItems);

  @override
  List<Object?> get props => super.groceryItems;
}

final class GroceriesError extends GroceriesState {
  GroceriesError(this.message) : super(<GroceryItem>[]);

  final String message;
  @override
  List<Object?> get props => super.groceryItems;
}
