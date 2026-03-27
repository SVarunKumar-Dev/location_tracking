import 'package:flutter/material.dart';

class DropdownField<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<T> items;
  final Function(T?) onChanged;

  const DropdownField({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      hint: Text(hint),
      initialValue: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
          .toList(),
      onChanged: onChanged,
    );
  }
}
