import 'package:flutter/material.dart';
import '../utility/date_formatter.dart';
import 'custom_text_field.dart';

class CustomDatePicker extends StatelessWidget {
  final String? label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? Function(String?)? validator;

  const CustomDatePicker({
    super.key,
    this.label = 'Date',
    required this.selectedDate,
    required this.onDateSelected,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController(
      text: selectedDate != null
          ? DateFormatter.formatShortDate(selectedDate!)
          : '',
    );

    return CustomTextField(
      label: label,
      hintText: 'Select Date',
      controller: textController,
      readOnly: true,
      prefixIcon: const Icon(Icons.calendar_today_outlined),
      suffixIcon: const Icon(Icons.arrow_drop_down),
      validator: validator,
      onTap: () async {
        final initial = selectedDate ?? DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
    );
  }
}
