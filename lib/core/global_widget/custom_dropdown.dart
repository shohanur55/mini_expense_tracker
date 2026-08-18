import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../utility/app_constants.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String? label;
  final String? hintText;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    this.label,
    this.hintText,
    required this.value,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 6.h),
        ],
        DropdownButtonFormField<T>(
          initialValue: value,
          onChanged: onChanged,
          validator: validator,
          decoration: AppDecorations.inputDecoration(
            context: context,
            hintText: hintText,
            prefixIcon: value != null
                ? Icon(
                    AppConstants.getCategoryIcon(itemLabelBuilder(value as T)),
                    color: AppColors.getCategoryColor(
                        itemLabelBuilder(value as T)),
                  )
                : const Icon(Icons.category_outlined),
          ),
          items: items.map((item) {
            final itemText = itemLabelBuilder(item);
            return DropdownMenuItem<T>(
              value: item,
              child: Row(
                children: [
                  Icon(
                    AppConstants.getCategoryIcon(itemText),
                    size: 18.r,
                    color: AppColors.getCategoryColor(itemText),
                  ),
                  SizedBox(width: 8.w),
                  Text(itemText),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
