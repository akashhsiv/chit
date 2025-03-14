import 'package:chit/modules/transaction/models/transaction.dart';
import 'package:chit/services/shared_pref_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionViewModel extends StateNotifier<List<ChitTransaction>> {
  TransactionViewModel() : super([]) {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    state = await SharedPrefsService.loadTransactions();
  }

  Future<void> addTransaction(ChitTransaction transaction) async {
    state = [...state, transaction];
    await SharedPrefsService.saveTransactions(state);
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
