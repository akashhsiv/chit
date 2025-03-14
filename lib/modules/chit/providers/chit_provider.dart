import 'package:chit/modules/chit/view_models/chit_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chit.dart';


final chitProvider = StateNotifierProvider<ChitViewModel, List<Chit>>(
  (ref) => ChitViewModel(),
);
