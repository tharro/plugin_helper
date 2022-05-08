// import 'package:bloc/bloc.dart';
// import '../../repositories/payment/payment_repositories.dart';
// import '../../utils/parse_error.dart';
// import 'package:equatable/equatable.dart';

// part 'credit_card_event.dart';
// part 'credit_card_state.dart';

// class CreditCardBloc extends Bloc<CreditCardEvent, CreditCardState> {
//   final PaymentRepositories paymentRepositories = PaymentRepositories();
//   CreditCardBloc() : super(CreditCardState.empty()) {
//     on<AddCreditCard>(_addCreditCard);
//   }

//   void _addCreditCard(
//       AddCreditCard event, Emitter<CreditCardState> emit) async {
//     try {
//       emit(state.copyWith(addCardLoading: true));
//       await paymentRepositories.addCard(body: event.body);
//       emit(state.copyWith(addCardLoading: false));
//       event.onSuccess();
//     } catch (e) {
//       emit(state.copyWith(addCardLoading: false));
//       ParseError error = ParseError.fromJson(e);
//       event.onError(error.code, error.message);
//     }
//   }
// }
