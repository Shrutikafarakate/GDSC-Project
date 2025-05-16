import 'package:flutter_test/flutter_test.dart';
import 'package:expense_manger/main.dart'; // Ensure this points to your main.dart file

void main() {
  testWidgets('Test the ExpenseTrackerApp', (WidgetTester tester) async {
    // Build the widget tree with the ExpenseTrackerApp
    await tester.pumpWidget(const ExpenseMasterApp());

    // Your test logic here
    // Example: Verify if the app loads by checking for a widget
    expect(
      find.text('Expense Tracker'),
      findsOneWidget,
    ); // Check if a text is found on the screen
  });
}
