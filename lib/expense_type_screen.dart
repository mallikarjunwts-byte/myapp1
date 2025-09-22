import 'package:flutter/material.dart';
import 'data_model.dart';
import 'package:myapp/expense_type_details_screen.dart';

class ExpenseTypeScreen extends StatefulWidget {
  const ExpenseTypeScreen({
    super.key,
    required this.expenses,
    required this.addExpenseType,
    required this.deleteExpenseType,
    required this.expenseTypes,
    required this.deleteExpense, // Add this
  });

  final List<Expense> expenses;
  final Function(String) addExpenseType;
  final Function(ExpenseType) deleteExpenseType;
  final List<ExpenseType> expenseTypes;
  final Function(Expense) deleteExpense; // Add this

  @override
  State<ExpenseTypeScreen> createState() => _ExpenseTypeScreenState();
}

class _ExpenseTypeScreenState extends State<ExpenseTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Expense Types'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.expenseTypes.length,
              itemBuilder: (context, index) {
                final type = widget.expenseTypes[index];
                final expensesForType = widget.expenses.where((expense) => expense.type == type).toList();

                return ListTile(
                  title: Text(type.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExpenseTypeDetailsScreen(
                          expenseType: type,
                          expenses: expensesForType,
                          deleteExpense: widget.deleteExpense, // Pass this
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      widget.deleteExpenseType(type);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Show add expense type dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    String newExpenseTypeName = '';
                    return AlertDialog(
                      title: const Text('Add Expense Type'),
                      content: TextField(
                        onChanged: (value) {
                          newExpenseTypeName = value;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Expense Type Name'),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            widget.addExpenseType(newExpenseTypeName);
                            Navigator.pop(context);
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  }
                );
              },
              child: const Text('Add Expense Type'),
            ),
          ),
        ],
      ),
    );
  }
}
