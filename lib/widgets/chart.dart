import 'package:flutter/material.dart';
import '../models/Transaction.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupTransctionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double dayTotal = 0;
      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          dayTotal += recentTransactions[i].amount;
        }
      }
      // print(DateFormat.E().format(weekDay));
      // print(dayTotal);

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1).toString(),
        'amount': dayTotal
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupTransctionsValues.fold(0, (sum, element) {
      return sum + (element['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                child: Text(
                  'Weekly spendings',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: groupTransctionsValues.map((data) {
                    return Flexible(
                      fit: FlexFit.tight,
                      child: ChartBar(
                          data['day'].toString(),
                          data['amount'] as double,
                          (data['amount'] as double) / totalSpending),
                    );
                  }).toList(),
                ),
              ),
            ],
          )),
    );
  }
}
