import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../theme/app_decorations.dart';

class CustomPasswordField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  final RxBool _obscureText = true.obs;

  CustomPasswordField({
    super.key,
    this.label,
    this.hintText = 'Enter password',
    this.controller,
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
        Obx(
          () => TextFormField(
            controller: controller,
            validator: validator,
            obscureText: _obscureText.value,
            decoration: AppDecorations.inputDecoration(
              context: context,
              hintText: hintText,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () => _obscureText.toggle(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
