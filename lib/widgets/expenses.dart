import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import '../model/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({
    super.key,
   });



  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Groceries',
      amount: 150.75,
      date: DateTime(2024, 7, 1),
      category: Category.food,
    ),
    Expense(
      title: 'Restaurant',
      amount: 85.50,
      date: DateTime(2024, 7, 3),
      category: Category.food,
    ),
    Expense(
      title: 'Movie Tickets',
      amount: 30.00,
      date: DateTime(2024, 6, 25),
      category: Category.leisure,
    ),
    Expense(
      title: 'Gym Membership',
      amount: 45.00,
      date: DateTime(2024, 7, 5),
      category: Category.leisure,
    ),
    Expense(
      title: 'Flight Tickets',
      amount: 500.00,
      date: DateTime(2024, 6, 20),
      category: Category.travel,
    ),
    Expense(
      title: 'Hotel Stay',
      amount: 300.00,
      date: DateTime(2024, 6, 22),
      category: Category.travel,
    ),
    Expense(
      title: 'Office Supplies',
      amount: 60.00,
      date: DateTime(2024, 6, 30),
      category: Category.work,
    ),
    Expense(
      title: 'Client Dinner',
      amount: 120.00,
      date: DateTime(2024, 7, 4),
      category: Category.work,
    ),
  ];




  void _openAddExpenseOverlay(){
    showModalBottomSheet(
      isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(onAddExpense: _addExpense,)
    );
  }

  void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense){
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: const Text('Expense deleted'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            },
          ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No Expense Found. Start Adding Some!'),
    );

    if(_registeredExpenses.isNotEmpty){
      mainContent =  ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title:  Text(
            "Flutter Expense Tracker",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white
            ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: _openAddExpenseOverlay,
          )
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(child:mainContent)
        ]
      ),
    );
  }

}
