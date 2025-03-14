import 'package:chit/modules/transaction/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPrefsService {
  static Future<int> getChitCounter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('chit_global_counter') ?? 0;
  }

  static Future<void> saveChitCounter(int counter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('chit_global_counter', counter);
  }

  static Future<List<ChitTransaction>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsData = prefs.getStringList('transactions') ?? [];

    return transactionsData.map((json) {
      return ChitTransaction.fromJson(jsonDecode(json));
    }).toList();
  }

  static Future<void> saveTransactions(
    List<ChitTransaction> transactions,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson =
        transactions.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList('transactions', transactionsJson);
  }
}
