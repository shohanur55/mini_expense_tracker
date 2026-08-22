import 'package:flutter/material.dart';
import '../utility/date_formatter.dart';
import 'custom_text_field.dart';

class CustomDatePicker extends StatefulWidget {
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
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.selectedDate != null
          ? DateFormatter.formatShortDate(widget.selectedDate!)
          : '',
    );
  }

  @override
  void didUpdateWidget(covariant CustomDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _controller.text = widget.selectedDate != null
          ? DateFormatter.formatShortDate(widget.selectedDate!)
          : '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.label,
      hintText: 'Select Date',
      controller: _controller,
      readOnly: true,
      prefixIcon: const Icon(Icons.calendar_today_outlined),
      suffixIcon: const Icon(Icons.arrow_drop_down),
      validator: widget.validator,
      onTap: () async {
        final initial = widget.selectedDate ?? DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          widget.onDateSelected(picked);
        }
      },
    );
  }
}
