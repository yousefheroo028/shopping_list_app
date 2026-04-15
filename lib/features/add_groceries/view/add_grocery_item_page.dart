import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app/core/enums/categories.dart';
import 'package:shopping_list_app/features/categories/model/category.dart';
import 'package:shopping_list_app/features/groceries/model/grocery_item.dart';
import 'package:shopping_list_app/features/groceries/view-model/groceries_cubit.dart';

class AddGroceryItemBottomSheet extends StatefulWidget {
  const AddGroceryItemBottomSheet({super.key});

  @override
  State<AddGroceryItemBottomSheet> createState() => _AddGroceryItemBottomSheetState();
}

class _AddGroceryItemBottomSheetState extends State<AddGroceryItemBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String name = '';
  int quantity = 0;
  CategoryEnum category = CategoryEnum.vegetables;

  final FocusNode nameTextFieldFocusNode = FocusNode();
  final FocusNode quantityTextFieldFocusNode = FocusNode();

  ValueNotifier<bool> isSending = ValueNotifier<bool>(false);

  Future<void> addNewGroceryItem() async {
    if (formKey.currentState!.validate()) {
      setState(() => isSending.value = true);
      formKey.currentState!.save();
      final http.Response response = await context.read<GroceriesCubit>().addGroceryItem(
        GroceryItem(
          name: name,
          quantity: quantity,
          category: category,
        ),
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully added a new grocery item')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add a new grocery item')),
        );
      }
      setState(() => isSending.value = false);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    nameTextFieldFocusNode.dispose();
    quantityTextFieldFocusNode.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .all(12.0),
    child: Form(
      key: formKey,
      child: Column(
        spacing: 16.0,
        children: <Widget>[
          TextFormField(
            autofocus: true,
            focusNode: nameTextFieldFocusNode,
            onFieldSubmitted: (String _) {
              quantityTextFieldFocusNode.requestFocus();
            },
            decoration: const InputDecoration(
              label: Text('Name'),
              border: OutlineInputBorder(),
            ),
            textCapitalization: .sentences,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              } else if (value.length > 50) {
                return 'Name must be less than 50 characters';
              }
              return null;
            },
            onSaved: (String? value) => name = value!,
            onTapOutside: (PointerDownEvent event) => FocusScope.of(context).unfocus(),
          ),
          Row(
            spacing: 16.0,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  focusNode: quantityTextFieldFocusNode,
                  onTapOutside: (PointerDownEvent event) => FocusScope.of(context).unfocus(),
                  decoration: const InputDecoration(
                    label: Text('Quantity'),
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (String? value) => quantity = int.parse(value!),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    } else if (int.parse(value) == 0) {
                      return 'Quantity must be greater than 0';
                    }
                    return null;
                  },
                ),
              ),
              Expanded(
                child: DropdownButtonFormField<CategoryEnum>(
                  initialValue: CategoryEnum.vegetables,
                  decoration: const InputDecoration(label: Text('Category')),
                  items: <DropdownMenuItem<CategoryEnum>>[
                    for (final MapEntry<CategoryEnum, Category> category in categories.entries)
                      DropdownMenuItem<CategoryEnum>(
                        value: category.key,
                        child: Row(
                          spacing: 8.0,
                          children: <Widget>[
                            ColoredBox(
                              color: category.value.color,
                              child: const SizedBox(height: 10.0, width: 10.0),
                            ),
                            Text(category.key.name),
                          ],
                        ),
                      ),
                  ],
                  menuMaxHeight: 200.0,
                  onChanged: (CategoryEnum? selectedCategory) {
                    category = selectedCategory!;
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: .end,
            spacing: 16.0,
            children: <Widget>[
              TextButton(onPressed: isSending.value ? null : () => Navigator.pop(context), child: const Text('Cancel')),
              ValueListenableBuilder<bool>(
                valueListenable: isSending,
                builder: (BuildContext context, dynamic value, Widget? child) => ElevatedButton(
                  onPressed: addNewGroceryItem,
                  child: isSending.value
                      ? const Center(
                          child: SizedBox(
                            height: 24.0,
                            width: 24.0,
                            child: RepaintBoundary(child: CircularProgressIndicator.adaptive(strokeWidth: 2.0)),
                          ),
                        )
                      : const Text('Add'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
