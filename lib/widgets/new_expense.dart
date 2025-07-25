
import 'dart:io';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({ super.key, required this.onAddExpense });

  final void Function(Expense expense) onAddExpense;

  State<NewExpense> createState() {
    return _NewExpenseState();
  }

}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.lesiure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void closeModal () {
    Navigator.pop(context);
  }

  void _showDatePicker () async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context, 
      initialDate: now, 
      firstDate: firstDate, 
      lastDate: now
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog () {
    if (Platform.isIOS) {
      showCupertinoDialog(context: context, builder: (ctx) => CupertinoAlertDialog(
        title: Text('Invalid Input'),
        content: Text('Please make sure a valid title, amount, date and category were entered.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            }, 
            child: Text('Okay'))
        ],
      ));
    } else {
      showDialog(context: context, builder: (ctx) => AlertDialog(
        title: Text('Invalid Input'),
        content: Text('Please make sure a valid title, amount, date and category were entered.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            }, 
            child: Text('Okay'))
        ],
      ));
    }
  }

  void _submitExpenseData () {
    final entertedAmount = double.tryParse(_amountController.text);
    final amountInvalid = entertedAmount == null || entertedAmount <= 0; 
    if (_titleController.text.trim().isEmpty || amountInvalid || _selectedDate == null) {
      _showDialog();
      return;
    }
    widget.onAddExpense(
      Expense(
        title: _titleController.text, 
        amount: entertedAmount, 
        date: _selectedDate!, 
        category: _selectedCategory
      )
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Expanded(
                       child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: InputDecoration(
                            label: Text('Title')
                          ),
                        ),
                     ),
                     SizedBox(width: 24),
                      Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          prefixText: '\$ ',
                          label: Text('Amount')
                        ),
                      ),
                    ),
                  ],)
                else
                TextField(
                  controller: _titleController,
                  maxLength: 50,
                  decoration: InputDecoration(
                    label: Text('Title')
                  ),
                ),
                if (width >= 600)
                  Row(children: [
                    DropdownButton(
                      value: _selectedCategory,
                      items: Category.values.map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name.toUpperCase()))).toList(), 
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    ),
                    SizedBox(width: 24),
                     Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Text(_selectedDate == null ? 'No date selected' : formatter.format(_selectedDate!)),
                        IconButton(
                          onPressed: _showDatePicker, 
                          icon: Icon(Icons.calendar_month)
                        )
                      ],),
                    )
                  ],)
                else
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          prefixText: '\$ ',
                          label: Text('Amount')
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Text(_selectedDate == null ? 'No date selected' : formatter.format(_selectedDate!)),
                        IconButton(
                          onPressed: _showDatePicker, 
                          icon: Icon(Icons.calendar_month)
                        )
                      ],),
                    )
                  ],
                ),
                SizedBox(height: 16),
                if (width >= 600)
                  Row(children: [
                    Spacer(),
                    TextButton(
                      onPressed: closeModal, 
                      child: Text('Cancel')
                    ),
                    ElevatedButton(
                      onPressed: _submitExpenseData, 
                      child: Text('Save Expense'))
                  ],)
                else

                Row(children: [
                  DropdownButton(
                    value: _selectedCategory,
                    items: Category.values.map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name.toUpperCase()))).toList(), 
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: closeModal, 
                    child: Text('Cancel')
                  ),
                  ElevatedButton(
                    onPressed: _submitExpenseData, 
                    child: Text('Save Expense'))
                ],)
              ],
            ),
          ),
        ),
      );
    });
  }
}