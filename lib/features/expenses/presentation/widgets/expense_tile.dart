
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  const ExpenseTile({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(      color: Colors.white,
          borderRadius: BorderRadius.circular(12.sp)
        ),
        child: ListTile(

          leading: const CircleAvatar(child: Icon(Icons.shopping_bag)),
          title: Text(expense.category),
          subtitle: Text(expense.date.toLocal().toString().split(' ').first),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${expense.amountOriginal.toStringAsFixed(2)} ${expense.currencyCode}'),
              Text('\$${expense.amountUsd.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
