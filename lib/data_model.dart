class ExpenseType {
  String name;

  ExpenseType({required this.name});
}

class Member {
  String name;

  Member({required this.name});
}

class Expense {
  double amount;
  Member payer;
  ExpenseType type;
  DateTime date;
  String? notes;
  bool isPaid;

  Expense({required this.amount, required this.payer, required this.type, required this.date, this.notes, this.isPaid = false});
}
