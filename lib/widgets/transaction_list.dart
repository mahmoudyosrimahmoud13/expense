import 'package:flutter/material.dart';
import '../models/Transaction.dart';
import 'TransctionItem.dart';

// ignore: must_be_immutable
class TransactionList extends StatelessWidget {
  TransactionList(this.transactions, this._deletedTransactions, {super.key});

  final Function _deletedTransactions;
  List<Transaction> transactions;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      child: transactions.isEmpty
          ? Column(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Image.asset(
                    'assets/images/upset.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "No inputs yet.",
                  style: Theme.of(context).textTheme.titleMedium,
                )
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return TransactionItem(
                    key: ValueKey(transactions[index].id),
                    transaction: transactions[index],
                    deletedTransactions: _deletedTransactions);
              },
              itemCount: transactions.length,
            ),
    );
  }
}
