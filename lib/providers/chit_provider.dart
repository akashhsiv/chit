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
    _initCounter();
  }

  static int autoGenratedId = 0;

  // Initialize counter at startup
  Future<void> _initCounter() async {
    final prefs = await SharedPreferences.getInstance();
    autoGenratedId = prefs.getInt('chit_global_counter') ?? 0;
  }

  // Save the updated counter
  Future<void> _saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('chit_global_counter', autoGenratedId);
  }

  // Add a new chit with auto-generated ID
  Future<void> addChit(String customerName, String phoneNumber) async {
    autoGenratedId++; // Increment counter
    final newChit = Chit(
      id: autoGenratedId,
      customerName: customerName,
      customerMobileNumber: phoneNumber,
    );

   
    state = [...state, newChit];

    await _saveCounter();
  }
}

class TransactionNotifier extends StateNotifier<List<ChitTransaction>> {
  TransactionNotifier() : super([]);

  void addTransaction(ChitTransaction transaction) {
    state = [...state, transaction];
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
