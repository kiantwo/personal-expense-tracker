import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:intl/intl.dart';

import 'classes/transaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'OpenSans',
      ),
      home: const PersonalExpenseTracker(),
    );
  }
}

class PersonalExpenseTracker extends StatefulWidget {
  const PersonalExpenseTracker({Key? key}) : super(key: key);

  @override
  State<PersonalExpenseTracker> createState() => _PersonalExpenseTrackerState();
}

class _PersonalExpenseTrackerState extends State<PersonalExpenseTracker> {
  final List<Transaction> _transactions = [];
  final _chartInfo = [
    {'expense': 0},
    {'expense': 0},
    {'expense': 0},
    {'expense': 0},
    {'expense': 0},
    {'expense': 0},
    {'expense': 0},
  ];
  final date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAsBottomSheet(context);
            },
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
            ),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                _buildChart(context),
                if (_transactions.isEmpty)
                  _buildEmptyTransaction()
                else
                  for (var transaction in _transactions) ...[
                    _buildCard(transaction),
                  ],
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAsBottomSheet(context);
        },
        backgroundColor: Colors.yellow.shade700,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildChart(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width * 0.90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 0; i < _chartInfo.length; i++)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  NumberFormat.currency(
                          locale: 'en-ph', decimalDigits: 0, symbol: '₱')
                      .format(_chartInfo[i]['expense']),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    fontFamily: 'QuickSand',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.125,
                  width: MediaQuery.of(context).size.width * 0.035,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    border: Border.all(color: Colors.grey),
                  ),
                ),
                Text(
                  DateFormat('EEE').format(date
                      .subtract(const Duration(days: 6))
                      .add(Duration(days: i))),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.0305,
                    fontFamily: 'QuickSand',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyTransaction() {
    return Column(
      children: [
        Text(
          'No transactions added yet!',
          style: TextStyle(
            fontFamily: 'QuickSand',
            fontWeight: FontWeight.w700,
            fontSize: MediaQuery.of(context).size.width * 0.045,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.0405,
        ),
        Opacity(
          opacity: 0.3,
          child: Image(
            image: const AssetImage('assets/images/waiting.png'),
            height: MediaQuery.of(context).size.height * 0.25,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(Transaction transaction) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30.0,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      NumberFormat.currency(
                              locale: 'en-ph', decimalDigits: 2, symbol: '₱')
                          .format(transaction.amount),
                      style: TextStyle(
                        fontFamily: 'QuickSand',
                        fontSize: MediaQuery.of(context).size.width * 0.029,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  transaction.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'QuickSand',
                  ),
                ),
                subtitle: Text(
                  DateFormat('MMMM dd, yyyy').format(transaction.date!),
                ),
                trailing: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
    );
  }

  void _showAsBottomSheet(context) async {
    // ignore: unused_local_variable
    final result = await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.4, 0.7, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) {
          return const TransactionForm();
        },
      );
    });
    if (result != null) {
      setState(() {
        _transactions.add(
          Transaction(
            title: result.title,
            amount: result.amount,
            date: result.date,
          ),
        );
      });
    }
  }
}

class TransactionForm extends StatefulWidget {
  const TransactionForm({Key? key}) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  DateTime? _date;
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final Transaction _transactionInfo = Transaction(title: '', amount: 0);
  bool _validate = false;

  @override
  void _dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: 'Title',
                  errorText: _titleController.text.isEmpty && _validate
                      ? 'Field is required'
                      : null,
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                controller: _titleController,
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: 'Amount',
                  errorText: _amountController.text.isEmpty && _validate
                      ? 'Field is required'
                      : null,
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: _amountController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        _date == null
                            ? 'No Date Chosen'
                            : 'Picked Date: ' +
                                DateFormat('MM/dd/yyyy').format(_date!),
                      ),
                      _date == null && _validate
                          ? const Text(
                              'Field is required.',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12.0,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: const Text(
                      'Choose Date',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _setTransactionInfo,
                    child: const Text('Add Transaction'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setTransactionInfo() {
    _titleController.text.isNotEmpty && _amountController.text.isNotEmpty
        ? setState(() {
            _validate = false;
          })
        : setState(() {
            _validate = true;
          });

    if (_titleController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        _date != null) {
      _transactionInfo.title = _titleController.text;
      _transactionInfo.amount = double.parse(_amountController.text);
      _transactionInfo.date = _date!;

      Navigator.pop(context, _transactionInfo);
    }
  }

  _selectDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() => _date = newDate);
  }
}
