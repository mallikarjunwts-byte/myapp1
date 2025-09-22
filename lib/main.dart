import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_model.dart';
import 'expense_type_screen.dart';
import 'member_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class AppState with ChangeNotifier {
  List<ExpenseType> expenseTypes = [ExpenseType(name: 'Food'), ExpenseType(name: 'Travel')];
  List<Member> members = [Member(name: 'Alice'), Member(name: 'Bob')];
  List<Expense> expenses = [];

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setSystemTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }

  void addExpenseType(String name) {
    expenseTypes.add(ExpenseType(name: name));
    notifyListeners();
  }

  void deleteExpenseType(ExpenseType type) {
    expenseTypes.remove(type);
    notifyListeners();
  }

  void addMember(String name) {
    members.add(Member(name: name));
    notifyListeners();
  }

  void deleteMember(Member member) {
    members.remove(member);
    notifyListeners();
  }

  void addExpense(double amount, Member payer, ExpenseType type, DateTime date, String? notes) {
    expenses.add(Expense(amount: amount, payer: payer, type: type, date: date, notes: notes, isPaid: false));
    notifyListeners();
  }

  void deleteExpense(Expense expense) {
    expenses.remove(expense);
    notifyListeners();
  }

  void updateExpensePaidStatus(Member member, bool isPaid) {
    for (var expense in expenses) {
      if (expense.payer == member) {
        expense.isPaid = isPaid;
      }
    }
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const MaterialColor primarySeedColor = Colors.deepPurple;

    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primarySeedColor,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primarySeedColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );

    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: primarySeedColor.shade200,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );

    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'Expense Share',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: appState.themeMode,
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Share'),
        actions: [
          IconButton(
            icon: Icon(appState.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => appState.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.auto_mode),
            onPressed: () => appState.setSystemTheme(),
            tooltip: 'Set System Theme',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExpenseTypeScreen(expenses: appState.expenses, addExpenseType: appState.addExpenseType, deleteExpenseType: appState.deleteExpenseType, expenseTypes: appState.expenseTypes, deleteExpense: appState.deleteExpense)),
                );
              },
              child: const Text('Manage Expense Types'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MemberScreen(addMember: appState.addMember, deleteMember: appState.deleteMember, members: appState.members)),
                );
              },
              child: const Text('Manage Members'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddExpenseScreen(addExpense: appState.addExpense, expenseTypes: appState.expenseTypes, members: appState.members)),
                );
              },
              child: const Text('Add Expense'),
            ),
            const Text(
              'Member Expenses:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: appState.members.length,
                itemBuilder: (context, index) {
                  final member = appState.members[index];
                  double totalExpense = 0;
                  bool isPaid = false;
                  for (var expense in appState.expenses) {
                    if (expense.payer == member) {
                      totalExpense += expense.amount;
                      isPaid = expense.isPaid;
                    }
                  }
                  return ListTile(
                    title: Text('${member.name}: \$${totalExpense.toStringAsFixed(2)}'),
                    trailing: Checkbox(
                      checkColor: Colors.green,
                      value: isPaid,
                      onChanged: (bool? value) {
                        appState.updateExpensePaidStatus(member, value ?? false);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key, required this.addExpense, required this.expenseTypes, required this.members});

  final Function(double, Member, ExpenseType, DateTime, String?) addExpense;
  final List<ExpenseType> expenseTypes;
  final List<Member> members;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  double _amount = 0;
  Member? _payer;
  ExpenseType? _type;
  final DateTime _date = DateTime.now();
  String? _notes;

  @override
  void initState() {
    super.initState();
    if (widget.members.isNotEmpty) {
      _payer = widget.members.first;
    }
    if (widget.expenseTypes.isNotEmpty) {
      _type = widget.expenseTypes.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              onChanged: (value) {
                setState(() {
                  _amount = double.tryParse(value) ?? 0;
                });
              },
            ),
            DropdownButtonFormField<Member>(
              decoration: const InputDecoration(
                labelText: 'Payer',
              ),
              initialValue: _payer,
              items: widget.members.map((Member member) => DropdownMenuItem<Member>(
                value: member,
                child: Text(member.name),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _payer = value;
                });
              },
            ),
            DropdownButtonFormField<ExpenseType>(
              decoration: const InputDecoration(
                labelText: 'Expense Type',
              ),
              initialValue: _type,
              items: widget.expenseTypes.map((ExpenseType type) => DropdownMenuItem<ExpenseType>(
                value: type,
                child: Text(type.name),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _type = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Notes (Max 100 characters)',
              ),
              maxLength: 100,
              onChanged: (value) {
                setState(() {
                  _notes = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: (_payer != null && _type != null) ? () {
                widget.addExpense(_amount, _payer!, _type!, _date, _notes);
                Navigator.pop(context);
              } : null,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
