import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_expense_tracker/classes/transaction.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Transaction> _transactions = [];
  //define fixed-size list
  final List<Transaction> _chartInfo =
      List<Transaction>.filled(7, Transaction());

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _chartInfo.length; i++) {
      _chartInfo[i] = Transaction(
          amount: 0,
          date: DateTime.now()
              .subtract(const Duration(days: 6))
              .add(Duration(days: i)));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addTransaction(Transaction transaction) {
    setState(() {
      _transactions.add(
        Transaction(
          title: transaction.title,
          amount: transaction.amount,
          date: transaction.date,
        ),
      );
      //pinpoint the day of transaction on the chart
      int indexOfChart = _chartInfo.indexWhere(
          (inf) => inf.date!.weekday.compareTo(transaction.date!.weekday) == 0);

      //add to the day's expense
      _chartInfo[indexOfChart].amount =
          _chartInfo[indexOfChart].amount! + transaction.amount!;
    });
  }

  void _removeTransaction(Transaction transaction) {
    setState(() {
      //pinpoint the day of transaction on the chart
      int indexOfChart = _chartInfo.indexWhere(
          (inf) => inf.date!.weekday.compareTo(transaction.date!.weekday) == 0);

      //subtract to the day's expense
      _chartInfo[indexOfChart].amount =
          _chartInfo[indexOfChart].amount! - transaction.amount!;

      _transactions.remove(transaction);
    });
  }

  double _getBarPercentage(double? dayAmount) {
    double maxContainerHeight = 0.125;
    double totalExpense = 0;
    double percentage = 0;

    for (var info in _chartInfo) {
      totalExpense = totalExpense + info.amount!;
    }

    //percentage value of transaction
    percentage = (dayAmount! / totalExpense) * 100;

    return percentage == 100.0
        ? maxContainerHeight
        : percentage / 800.0; // 100 / 800 === maxContainerHeight
  }

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
                _buildChartContainer(context),
                if (_transactions.isEmpty)
                  _buildEmptyTransaction()
                else
                  for (var transaction in _transactions) ...[
                    _buildCard(transaction),
                  ],
                //account for the card at the very bottom and the floatingActionButton
                SizedBox(height: MediaQuery.of(context).size.height * 0.125),
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

  Widget _buildChartContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width * 0.90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var info in _chartInfo)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        NumberFormat.currency(
                                locale: 'en-ph', decimalDigits: 0, symbol: '₱')
                            .format(info.amount),
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          fontFamily: 'QuickSand',
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                      ),
                    ),
                    //chart bar
                    _buildChartGraph(info.amount),
                    Text(
                      DateFormat('EEE').format(info.date!),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.0305,
                        fontFamily: 'QuickSand',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartGraph(double? dayAmount) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height *
              0.125, //maxHeight of chart bar
          width: MediaQuery.of(context).size.width * 0.035,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.grey),
          ),
        ),
        //chart bar fill
        _transactions.isEmpty
            ? const SizedBox(height: 0.0)
            : Container(
                height: MediaQuery.of(context).size.height *
                    _getBarPercentage(dayAmount),
                width: MediaQuery.of(context).size.width * 0.035,
                decoration: const BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
      ],
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
              padding: const EdgeInsets.all(8.0),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'QuickSand',
                  ),
                ),
                trailing: InkWell(
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () => _removeTransaction(transaction),
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
    //receive popped variable
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
      //insert popped variable to List of Transactions
      _addTransaction(result);
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
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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

  //Set User Inputs to Transaction
  void _setTransactionInfo() {
    //check for validation
    if (_titleController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        double.parse(_amountController.text) != 0 &&
        _date != null) {
      setState(() {
        _validate = false;
      });

      _transactionInfo.title = _titleController.text;
      _transactionInfo.amount = double.parse(_amountController.text);
      _transactionInfo.date = _date!;

      //Back to Main Widget
      Navigator.pop(context, _transactionInfo);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  //Date picker
  _selectDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,

      //only make dates from current week available
      firstDate: DateTime.now().subtract(const Duration(days: 6)),
      lastDate: DateTime.now(),
    );

    if (newDate == null) return;

    //set newDate value to _date
    setState(() => _date = newDate);
  }
}
