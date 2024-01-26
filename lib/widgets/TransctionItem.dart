// ignore: file_names
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    required Function deletedTransactions,
  }) : _deletedTransactions = deletedTransactions;

  final transaction;
  final Function _deletedTransactions;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  late Color _backgroundColor;

  @override
  void initState() {
    List colors = [
      HexColor('#6C22A6'),
      HexColor('#6962AD'),
      HexColor('#83C0C1'),
      HexColor('#96E9C6'),
      HexColor('#F4F27E'),
    ];
    _backgroundColor = colors[Random().nextInt(5)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          widget._deletedTransactions(widget.transaction);
        },
        background: Container(
          padding: EdgeInsets.all(15),
          // decoration: BoxDecoration(),
          color: Color.fromARGB(94, 244, 67, 54),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.delete_forever_rounded),
              Icon(Icons.delete_forever_rounded)
            ],
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: _backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: FittedBox(
                child: Text(
                  '\$ ${widget.transaction.amount}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          ),
          title: Text(
            widget.transaction.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(DateFormat().format(widget.transaction.date)),
          trailing: MediaQuery.of(context).size.width > 460
              ? TextButton.icon(
                  onPressed: () =>
                      widget._deletedTransactions(widget.transaction),
                  label: const Text('Delete'),
                  icon: const Icon(Icons.delete_forever_rounded),
                )
              : IconButton(
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () =>
                      widget._deletedTransactions(widget.transaction),
                ),
        ),
      ),
    );
  }
}
