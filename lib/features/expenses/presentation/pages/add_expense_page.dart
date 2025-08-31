import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_picker/image_picker.dart';

import '../blocs/add_expense/add_expense_bloc.dart';
import '../blocs/add_expense/add_expense_event.dart';
import '../blocs/add_expense/add_expense_state.dart';
import '../blocs/list_expenses/list_expenses_bloc.dart';
import '../blocs/list_expenses/list_expenses_event.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  String? _selectedCategory;
  String? _currencyCode = "USD";
  File? _receipt;
  DateTime _selectedDate = DateTime.now();

  final List<Map<String, dynamic>> categories = [
    {
      "icon": Icons.shopping_cart,
      "label": "Groceries",
      "color": Colors.green.withValues(alpha: 0.2)
    },
    {
      "icon": Icons.movie,
      "label": "Entertainment",
      "color": Colors.purple.withValues(alpha: 0.2)
    },
    {
      "icon": Icons.local_gas_station,
      "label": "Gas",
      "color": Colors.orange.withValues(alpha: 0.2)
    },
    {
      "icon": Icons.shopping_bag,
      "label": "Shopping",
      "color": Colors.blue.withValues(alpha: 0.2)
    },
    {
      "icon": Icons.newspaper,
      "label": "News Paper",
      "color": Colors.teal.withValues(alpha: 0.2)
    },
    {
      "icon": Icons.directions_car,
      "label": "Transport",
      "color": Colors.red.withValues(alpha: 0.2)
    },
    {
      "icon": Icons.home,
      "label": "Rent",
      "color": Colors.brown.withValues(alpha: 0.2)
    },
    {
      "icon": Icons.add,
      "label": "Add Category",
      "color": Colors.grey.withValues(alpha: 0.2)
    },
  ];

  final List<String> currencies = ["USD", "EUR", "EGP", "SAR"];

  Future<void> _pickReceipt() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _receipt = File(picked.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddExpenseBloc, AddExpenseState>(
        listener: (context, state) {
          if (state.success) {
            context.read<ListExpensesBloc>().add(const LoadFirstPage());

            Navigator.pop(context, true);
          } else if (state.error.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to add expense")),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FB),
          appBar: AppBar(
            title: const Text("Add Expense"),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 18.sp),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _CustomInputField(
                        controller: _amountCtrl,
                        label: "Amount",
                        hint: "Enter amount",
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.isEmpty) return "Required";
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Category dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: "Category",
                          ),
                          items: categories.map((c) {
                            return DropdownMenuItem<String>(
                              value: c["label"],
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: c["color"],
                                    child: Icon(c["icon"], color: Colors.black),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(c["label"]),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _selectedCategory = val),
                          validator: (val) =>
                              val == null ? "Select category" : null,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Currency dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _currencyCode,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: "Currency",
                          ),
                          items: currencies
                              .map((c) =>
                                  DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _currencyCode = val),
                          validator: (val) =>
                              val == null ? "Select currency" : null,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Date Picker
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Colors.indigo),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "${_selectedDate.toLocal()}".split(' ')[0],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Upload Receipt
                      GestureDetector(
                        onTap: _pickReceipt,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.upload_file,
                                  color: Colors.indigo),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _receipt == null
                                      ? "Upload Receipt"
                                      : "Selected: ${_receipt!.path.split('/').last}",
                                  style: TextStyle(
                                    color: _receipt == null
                                        ? Colors.grey.shade600
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (_receipt != null) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_receipt!,
                              height: 120, fit: BoxFit.cover),
                        ),
                      ],

                      const SizedBox(height: 24),

                      Container(
                        width: MediaQuery.of(context).size.width * .8,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Update the bloc state with form data
                              context.read<AddExpenseBloc>()
                                ..add(CategorySelected(_selectedCategory!))
                                ..add(CurrencyChanged(_currencyCode!))
                                ..add(DateChanged(_selectedDate))
                                ..add(AmountChanged(
                                    double.tryParse(_amountCtrl.text) ?? 0.0));

                              if (_receipt?.path != null) {
                                context
                                    .read<AddExpenseBloc>()
                                    .add(ReceiptSelected(_receipt!.path));
                              }

                              // Save the expense
                              context.read<AddExpenseBloc>().add(SaveExpense());
                            }
                          },
                          child: const Text("Save"),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    )),
                const SizedBox(height: 20),
                AnimationLimiter(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: .8,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];

                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        columnCount: 4,
                        child: ScaleAnimation(
                          scale: 0.5,
                          child: FadeInAnimation(
                            child: SlideAnimation(
                              verticalOffset: 30.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(16.0.sp),
                                    decoration: BoxDecoration(
                                      color: category["color"],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      category["icon"],
                                      size: 40,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 5.sp),
                                  Text(
                                    category["label"],
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class _CustomInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _CustomInputField({
    this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.indigo, width: 1.5),
        ),
      ),
    );
  }
}
