import 'package:shopping_list_app/features/categories/model/category.dart';

enum CategoryEnum { vegetables, fruit, meat, dairy, carbs, sweets, spices, convenience, hygiene, other }

const Map<CategoryEnum, Category> categories = <CategoryEnum, Category>{
  CategoryEnum.vegetables: Category.vegetables(),
  CategoryEnum.fruit: Category.fruit(),
  CategoryEnum.meat: Category.meat(),
  CategoryEnum.dairy: Category.dairy(),
  CategoryEnum.carbs: Category.carbs(),
  CategoryEnum.sweets: Category.sweets(),
  CategoryEnum.spices: Category.spices(),
  CategoryEnum.convenience: Category.convenience(),
  CategoryEnum.hygiene: Category.hygiene(),
  CategoryEnum.other: Category.other(),
};
