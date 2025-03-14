import 'package:chit/modules/transaction/view_models/transaction_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';

final transactionProvider =
    StateNotifierProvider<TransactionViewModel, List<ChitTransaction>>(
      (ref) => TransactionViewModel(),
    );
