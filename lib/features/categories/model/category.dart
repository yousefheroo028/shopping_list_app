import 'dart:ui';

class Category {
  final String title;
  final Color color;
  const Category(this.title, this.color);

  const Category.vegetables() : this('Vegetables', const Color.fromARGB(255, 0, 255, 128));
  const Category.fruit() : this('Fruit', const Color.fromARGB(255, 145, 255, 0));
  const Category.meat() : this('Meat', const Color.fromARGB(255, 255, 102, 0));
  const Category.dairy() : this('Dairy', const Color.fromARGB(255, 0, 208, 255));
  const Category.carbs() : this('Carbs', const Color.fromARGB(255, 0, 60, 255));
  const Category.sweets() : this('Sweets', const Color.fromARGB(255, 255, 149, 0));
  const Category.spices() : this('Spices', const Color.fromARGB(255, 255, 187, 0));
  const Category.convenience() : this('Convenience', const Color.fromARGB(255, 191, 0, 255));
  const Category.hygiene() : this('Hygiene', const Color.fromARGB(255, 149, 0, 255));
  const Category.other() : this('Other', const Color.fromARGB(255, 0, 225, 255));
}
