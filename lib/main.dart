import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import './widgets/new_transaction.dart';
import './models/Transaction.dart';
import './widgets/transaction_list.dart';
import 'package:google_fonts/google_fonts.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: HexColor('#F2AFEF')),
        textTheme: TextTheme(
            titleLarge: GoogleFonts.tektur(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.cyan[200]),
            titleMedium: GoogleFonts.tektur(
                textStyle:
                    TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            titleSmall: GoogleFonts.tektur(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.cyan[200])),
        useMaterial3: true,
        dialogBackgroundColor: Colors.red[200],
      ),
      darkTheme: ThemeData(
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.cyan[200])),
        useMaterial3: true,
        dialogBackgroundColor: Colors.red[200],
        brightness: Brightness.dark,
        textTheme: TextTheme(
            titleLarge: GoogleFonts.tektur(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.cyan[200]),
            titleMedium: GoogleFonts.tektur(
                textStyle:
                    TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            titleSmall:
                GoogleFonts.tektur(fontSize: 18, fontWeight: FontWeight.bold)),
        primaryTextTheme:
            TextTheme(bodyLarge: TextStyle(color: Colors.cyan[100])),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(id: 5, title: '5', amount: 5, date: DateTime.now())
  ];
  bool showChart = false;
  List<Transaction> get _recentTransctions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    setState(() {
      _userTransactions.add(Transaction(
          id: DateTime.now().second.toString(),
          title: title,
          amount: amount,
          date: date));
      Navigator.pop(context);
    });
  }

  void _deleteTransaction(Transaction transaction) {
    setState(() {
      _userTransactions.remove(transaction);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('${transaction.title} deleted'),
          backgroundColor: Theme.of(context).primaryColorLight,
          action: SnackBarAction(
              label: 'Undo',
              onPressed: () => setState(() {
                    _userTransactions.add(transaction);
                  }))),
    );
  }

  void addButtomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
    );
  }

  // late String id;
  TextStyle font = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  Widget _buildLandScapeContent() {
    return Center(
      child: Switch.adaptive(
          value: showChart,
          onChanged: (value) {
            setState(() {
              showChart = value;
            });
          }),
    );
  }

  Widget _buildPortraitContent(Widget txListWidget, AppBar appBar) {
    return Column(
      children: [
        Container(
            height: (MediaQuery.sizeOf(context).height -
                    appBar.preferredSize.height -
                    MediaQuery.paddingOf(context).top) *
                0.3,
            child: Chart(_userTransactions)),
        txListWidget
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final islandScape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final appBar = AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Expenses',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Icon(
            Icons.wallet,
            size: 40,
            color: Theme.of(context).primaryColorLight,
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {
              addButtomSheet(context);
            },
            icon: Icon(Icons.add))
      ],
    );
    final txListWidget = Container(
        height: (MediaQuery.sizeOf(context).height -
                appBar.preferredSize.height -
                MediaQuery.paddingOf(context).top) *
            0.7,
        child: TransactionList(_recentTransctions, _deleteTransaction));
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            islandScape && !Platform.isWindows
                ? _buildLandScapeContent()
                : Row(),
            // ignore: sized_box_for_whitespace
            islandScape && !Platform.isWindows
                ? showChart
                    ? _userTransactions.isNotEmpty
                        ? Container(
                            height: (MediaQuery.sizeOf(context).height -
                                    appBar.preferredSize.height -
                                    MediaQuery.paddingOf(context).top) *
                                0.6,
                            child: Chart(_userTransactions))
                        : txListWidget
                    : txListWidget
                : _userTransactions.isNotEmpty
                    ? _buildPortraitContent(txListWidget, appBar)
                    : txListWidget,
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation:
          Platform.isAndroid ? FloatingActionButtonLocation.centerFloat : null,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_card_rounded),
        onPressed: () => addButtomSheet(context),
      ),
    );
  }
}
