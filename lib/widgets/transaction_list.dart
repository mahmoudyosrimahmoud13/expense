import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Transaction.dart';

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
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).dialogBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: FittedBox(
                          child: Text(
                            '\$ ${transactions[index].amount}',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      transactions[index].title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle:
                        Text(DateFormat().format(transactions[index].date)),
                    trailing: MediaQuery.of(context).size.width > 460
                        ? TextButton.icon(
                            onPressed: () =>
                                _deletedTransactions(transactions[index].id),
                            label: const Text('Delete'),
                            icon: const Icon(Icons.delete_forever_rounded),
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () =>
                                _deletedTransactions(transactions[index].id),
                          ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}
