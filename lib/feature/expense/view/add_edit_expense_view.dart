import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/global_widget/custom_button.dart';
import '../../../core/global_widget/custom_date_picker.dart';
import '../../../core/global_widget/custom_dropdown.dart';
import '../../../core/global_widget/custom_text_field.dart';
import '../../../core/utility/app_constants.dart';
import '../../../core/validation/form_validator.dart';
import '../controller/expense_controller.dart';

class AddEditExpenseView extends GetView<ExpenseController> {
  final bool isEditing;

  const AddEditExpenseView({super.key, this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Expense' : 'Add Expense'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Amount Field
                CustomTextField(
                  label: 'Amount (${AppConstants.currencySymbol})',
                  hintText: '0.00',
                  controller: controller.amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: const Icon(Icons.attach_money),
                  validator: FormValidation.validateAmount,
                ),
                SizedBox(height: 20.h),

                // Category Field
                Obx(
                  () => CustomDropdown<String>(
                    label: 'Category',
                    hintText: 'Select Expense Category',
                    value: controller.selectedCategory.value,
                    items: AppConstants.categories,
                    itemLabelBuilder: (cat) => cat,
                    onChanged: (val) {
                      controller.selectedCategory.value = val;
                    },
                    validator: (val) =>
                        FormValidation.validateRequired(val, 'Category'),
                  ),
                ),
                SizedBox(height: 20.h),

                // Date Picker Field
                Obx(
                  () => CustomDatePicker(
                    label: 'Expense Date',
                    selectedDate: controller.selectedDate.value,
                    onDateSelected: (date) {
                      controller.selectedDate.value = date;
                    },
                  ),
                ),
                SizedBox(height: 20.h),

                // Short Note Field (Optional)
                CustomTextField(
                  label: 'Description / Note (Optional)',
                  hintText: 'Add notes (e.g., Dinner with team)',
                  controller: controller.noteController,
                  maxLines: 3,
                  prefixIcon: const Icon(Icons.note_alt_outlined),
                ),
                SizedBox(height: 32.h),

                // Save Button
                Obx(
                  () => CustomButton(
                    text: isEditing ? 'Update Expense' : 'Save Expense',
                    icon: isEditing ? Icons.edit : Icons.check,
                    isLoading: controller.isSaving.value,
                    onPressed: controller.saveExpense,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
