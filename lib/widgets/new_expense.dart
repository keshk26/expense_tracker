
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({ super.key });

  State<NewExpense> createState() {
    return _NewExpenseState();
  }

}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

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


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: InputDecoration(
              label: Text('Title')
            ),
          ),
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
          Row(children: [
            TextButton(
              onPressed: closeModal, 
              child: Text('Cancel')
            ),
            ElevatedButton(
              onPressed: () {}, 
              child: Text('Save Expense'))
          ],)
        ],
      ),
    );
  }
}