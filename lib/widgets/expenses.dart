
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({ super.key });

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course', 
      amount: 19.99, 
      date: DateTime.now(), 
      category: Category.work
    ),
    Expense(
      title: 'Cinema', 
      amount: 15.69, 
      date: DateTime.now(), 
      category: Category.lesiure
    )
  ];

  void _openExpenseModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context, 
      builder: (ctx) => NewExpense(onAddExpense: _addExpense)
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo', 
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          }
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
   final width = MediaQuery.of(context).size.width;

   Widget mainContent = Center(
    child: Text('No expenses found. Start adding some!'),
   );
   
   if (_registeredExpenses.isNotEmpty) {
    mainContent = ExpensesList(expenses: _registeredExpenses, onRemoveExpense: _removeExpense);
   }

   return Scaffold(
    appBar: AppBar(
      title: Text('Flutter Expense Tracker'),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: _openExpenseModal
        )
      ]
    ),
    body: width < 600 ? Column(
      children: [
        Chart(expenses: _registeredExpenses),
        Expanded(
          child: mainContent
        )
      ],
    ) : Row(
      children: [
        Expanded(child: Chart(expenses: _registeredExpenses)),
        Expanded(
          child: mainContent
        )
      ],
    ),
   );
  }
}