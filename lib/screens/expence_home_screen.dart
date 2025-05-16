import 'package:expense_manger/screens/add_tranc.dart';
import 'package:expense_manger/screens/DonutChartScreen.dart';
import 'package:expense_manger/screens/report.dart';
import 'package:expense_manger/screens/transc_screen.dart';
import 'package:expense_manger/screens/profile_screen.dart'; // 👈 Import profile screen
import 'package:flutter/material.dart';

class ExpenseHomeScreen extends StatefulWidget {
  const ExpenseHomeScreen({super.key});

  @override
  _ExpenseHomeScreenState createState() => _ExpenseHomeScreenState();
}

class _ExpenseHomeScreenState extends State<ExpenseHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const TransactionScreen(),
    const AddTransactionScreen(),
    const DonutChartScreen(),
    const ReportsScreen(),
    const ProfileScreen(), // ✅ Fixed
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('GFG Expense Tracker'),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Income',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile', // 👈 Profile label
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
