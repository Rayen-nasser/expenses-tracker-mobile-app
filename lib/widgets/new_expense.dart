import 'package:flutter/material.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:intl/intl.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({
    super.key,
    required this.onAddExpense
  });

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  final DateFormat formatter = DateFormat.yMd();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDateDialog() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsValid = enteredAmount == null || enteredAmount <= 0;
    if(_titleController.text.trim().isEmpty || amountIsValid || _selectedDate == null){
      showDialog(context: context, builder: (ctx) =>
        AlertDialog(
          title: const Text("Invalid input"),
          content: const Text("Please make sure a valid title, amount, date and cateegory was entered. "),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                }, child: const Text('okay')
            )
          ],
        ),
      );
      return;
    }

    final expense = Expense(
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    );

    widget.onAddExpense(expense);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16,64,16,16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            maxLength: 50,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'Enter Expense Title',
              border: OutlineInputBorder(),
            ),
            controller: _titleController,
          ),
          const SizedBox(height: 16.0), // Add some space between fields
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    prefixText: 'TND ',
                    labelText: 'Amount',
                    hintText: 'Enter Expense Amount',
                    border: OutlineInputBorder(),
                  ),
                  controller: _amountController,
                ),
              ),
              const SizedBox(width: 16.0), // Add some space between the amount and date fields
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'No Selected'
                            : formatter.format(_selectedDate!),
                      ),
                      IconButton(
                        onPressed: _presentDateDialog,
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0), // Add some space between fields
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Category>(
                value: _selectedCategory,
                items: Category.values.map(
                      (category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name.toUpperCase()),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                isExpanded: true,
              ),
            ),
          ),
          const SizedBox(height: 16.0), // Add some space between fields
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 16.0), // Add some space between buttons
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: const Text("Save Expense"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

