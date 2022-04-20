// import 'package:bloc/bloc.dart';
// import '../../repositories/payment/payment_repositories.dart';
// import '../../utils/parse_error.dart';
// import 'package:equatable/equatable.dart';

// part 'bank_event.dart';
// part 'bank_state.dart';

// class BankBloc extends Bloc<BankEvent, BankState> {
//   final PaymentRepositories paymentRepositories = PaymentRepositories();
//   BankBloc() : super(BankState.empty()) {
//     on<AddBank>(_addCreditCard);
//   }

//   void _addCreditCard(AddBank event, Emitter<BankState> emit) async {
//     try {
//       emit(state.copyWith(addBankLoading: true));
//       await paymentRepositories.addOrUpdateBank(body: event.body);
//       emit(state.copyWith(addBankLoading: false));
//       event.onSuccess();
//     } catch (e) {
//       emit(state.copyWith(addBankLoading: false));
//       ParseError error = ParseError.fromJson(e);
//       event.onError(error.code, error.message);
//     }
//   }
// }
