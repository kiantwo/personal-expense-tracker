import 'package:flutter/material.dart';

class Transaction {
  String title;
  double amount = 0;
  DateTime? date;

  Transaction({required this.title, required this.amount, this.date});
}
