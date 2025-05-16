import 'package:expense_manger/models/trancs.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _category = 'Food';
  double _amount = 0.0;
  bool _isIncome = false;
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = [
    'Salary',
    'Food',
    'Transportation',
    'Entertainment',
    'Shopping',
    'Health',
    'Utilities',
    'Education',
    'Travel',
    'Bills',
    'Gifts',
    'Other',
  ];

  double _calculateBalance(Box box) {
    double income = 0, expense = 0;
    for (var item in box.values) {
      final transaction = item as Transaction;
      if (transaction.isIncome) {
        income += transaction.amount;
      } else {
        expense += transaction.amount;
      }
    }
    return income - expense;
  }

  @override
  Widget build(BuildContext context) {
    final Box box = Hive.box('transactions');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Balance display
          Card(
            color: Colors.deepPurple[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.deepPurple,
                    size: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Remaining Balance",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "₹${_calculateBalance(box).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Transaction Form
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _amount = double.parse(value!),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter an amount'
                              : null,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    prefixIcon: const Icon(Icons.category),
                  ),
                  icon: const Icon(Icons.arrow_drop_down),
                  onChanged: (newValue) {
                    setState(() {
                      _category = newValue!;
                      _isIncome = (_category == 'Salary');
                    });
                  },
                  items: _categories.map((value) {
                    IconData icon;
                    switch (value) {
                      case 'Food':
                        icon = Icons.fastfood;
                        break;
                      case 'Transportation':
                        icon = Icons.directions_car;
                        break;
                      case 'Health':
                        icon = Icons.local_hospital;
                        break;
                      case 'Education':
                        icon = Icons.school;
                        break;
                      default:
                        icon = Icons.category;
                    }
                    return DropdownMenuItem(
                      value: value,
                      child: Row(
                        children: [
                          Icon(icon, color: Colors.deepPurple),
                          const SizedBox(width: 10),
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Switch for Income (only if category is not Salary)
                if (_category != 'Salary')
                  SwitchListTile(
                    title: const Text('Is Income?'),
                    value: _isIncome,
                    onChanged: (val) {
                      setState(() => _isIncome = val);
                    },
                    secondary: Icon(
                      _isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                      color: _isIncome ? Colors.green : Colors.red,
                    ),
                  ),
                const SizedBox(height: 16),

                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: Text(
                    'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: _submitTransaction,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Transaction"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitTransaction() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final transaction = Transaction(
        category: _category,
        amount: _amount,
        isIncome: _isIncome,
        date: _selectedDate,
      );
      Hive.box('transactions').add(transaction);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaction added successfully!")),
      );

      // Reset form
      setState(() {
        _category = 'Food';
        _amount = 0.0;
        _isIncome = false;
        _selectedDate = DateTime.now();
      });
      _formKey.currentState!.reset();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }
}
