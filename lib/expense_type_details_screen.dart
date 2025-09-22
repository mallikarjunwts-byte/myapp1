import 'package:flutter/material.dart';
import 'data_model.dart';

class ExpenseTypeDetailsScreen extends StatelessWidget {
  const ExpenseTypeDetailsScreen({
    super.key,
    required this.expenseType,
    required this.expenses,
    required this.deleteExpense, // Add this
  });

  final ExpenseType expenseType;
  final List<Expense> expenses;
  final Function(Expense) deleteExpense; // Add this

  @override
  Widget build(BuildContext context) {
    final expensesForType = expenses.where((expense) => expense.type.name == expenseType.name).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(expenseType.name),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Expenses for ${expenseType.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expensesForType.length,
              itemBuilder: (context, index) {
                final expense = expensesForType[index];
                return Card(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Member: ${expense.payer.name}'),
                        Text('Amount: \$${expense.amount}'),
                        Text('Date: ${expense.date.toString().substring(0, 10)}'),
                        if (expense.notes != null) Text('Notes: ${expense.notes}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteExpense(expense);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
