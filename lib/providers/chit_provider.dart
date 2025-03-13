import 'package:chit/models/chit_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final chitProvider = StateNotifierProvider<ChitNotifier, List<Chit>>(
  (ref) => ChitNotifier(),
);
final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<ChitTransaction>>(
      (ref) => TransactionNotifier(),
    );

class ChitNotifier extends StateNotifier<List<Chit>> {
  ChitNotifier() : super([]) {
    initCounter();
  }

  static int autoGenratedId = 0;


  Future<void>initCounter() async {
    final prefs = await SharedPreferences.getInstance();
    autoGenratedId = prefs.getInt('chit_global_counter') ?? 0;
  }

  Future<void> saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('chit_global_counter', autoGenratedId);
  }

  Future<void> addChit(String customerName, String phoneNumber) async {
    autoGenratedId++; 
    final newChit = Chit(
      id: autoGenratedId,
      customerName: customerName,
      customerMobileNumber: phoneNumber,
    );

   
    state = [...state, newChit];

    await saveCounter();
  }
}
class TransactionNotifier extends StateNotifier<List<ChitTransaction>> {
  TransactionNotifier() : super([]) {
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsData = prefs.getStringList('transactions') ?? [];

    state =
        transactionsData.map((json) {
          return ChitTransaction.fromJson(json);
        }).toList();
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = state.map((t) => t.toJson()).toList();
    await prefs.setStringList('transactions', transactionsJson);
  }

  void addTransaction(ChitTransaction transaction) {
    state = [...state, transaction];
    _saveTransactions(); // Save to SharedPreferences
  }

  List<ChitTransaction> getTransactionsByChitId(int chitId) {
    return state.where((transaction) => transaction.chitId == chitId).toList();
  }

  int getTotalAmountByChitId(int chitId) {
    return state
        .where((transaction) => transaction.chitId == chitId)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }
}


