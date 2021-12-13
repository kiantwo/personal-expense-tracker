import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:intl/intl.dart';

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
  final _chartInfo = [
    {
      'expense': 0,
      'day': 'Tue',
    },
    {
      'expense': 0,
      'day': 'Wed',
    },
    {
      'expense': 0,
      'day': 'Thu',
    },
    {
      'expense': 0,
      'day': 'Fri',
    },
    {
      'expense': 0,
      'day': 'Sat',
    },
    {
      'expense': 0,
      'day': 'Sun',
    },
    {
      'expense': 0,
      'day': 'Mon',
    },
  ];

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
        child: Column(
          children: [
            _buildChart(context),
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
              opacity: 0.5,
              child: Image(
                image: const AssetImage('assets/images/waiting.png'),
                height: MediaQuery.of(context).size.height * 0.30,
                fit: BoxFit.cover,
              ),
            ),
          ],
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
                  _chartInfo[i]['day'] as String,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.0305,
                    fontFamily: 'QuickSand',
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showAsBottomSheet(context) async {
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
  }
}

class TransactionForm extends StatefulWidget {
  const TransactionForm({Key? key}) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  DateTime? date;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Material(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 10.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Title',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Amount',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getDate(),
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
                    onPressed: () {},
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

  _selectDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() => date = newDate);
  }

  String getDate() {
    if (date == null) {
      return 'No Date Chosen';
    } else {
      return 'Picked Date: ' + DateFormat('MM/dd/yyyy').format(date!);
    }
  }
}
