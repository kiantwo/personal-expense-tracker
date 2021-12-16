import 'package:flutter/material.dart';

class Transaction {
  String title;
  double? amount;
  DateTime? date;

  Transaction({this.title = '', this.amount = 0, this.date});
}
