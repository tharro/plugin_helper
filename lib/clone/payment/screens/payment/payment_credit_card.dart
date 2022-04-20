// import '../../blocs/payment/credit_card/credit_card_bloc.dart';
// import '../../utils/helper.dart';
// import '../../widgets/credit_card_custom.dart';
// import '../../widgets/overlay_loading_custom.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:plugin_helper/plugin_payment.dart';
// import 'package:plugin_helper/widgets/credit_card/credit_card_model.dart';

// class PaymentCreditCard extends StatefulWidget {
//   const PaymentCreditCard({Key? key}) : super(key: key);

//   @override
//   State<PaymentCreditCard> createState() => _PaymentCreditCardState();
// }

// class _PaymentCreditCardState extends State<PaymentCreditCard> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;

//   @override
//   void initState() {
//     MyPluginPayment.init();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CreditCardBloc, CreditCardState>(
//       builder: (context, state) {
//         return OverlayLoadingCustom(
//             isLoading: _isLoading || state.addCardLoading!,
//             child: Scaffold(
//                 body: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   CreditCardCustom(
//                     formKey: _formKey,
//                     onPress: (CreditCardModel card) async {
//                       if (_formKey.currentState!.validate()) {
//                         setState(() {
//                           _isLoading = true;
//                         });
//                         String tokenId =
//                             await MyPluginPayment.createTokenWidthCreditCard(
//                                 data: card);
//                         setState(() {
//                           _isLoading = false;
//                         });
//                         Map<String, dynamic> body = {
//                           'pm_id': tokenId,
//                         };
//                         BlocProvider.of<CreditCardBloc>(context)
//                             .add(AddCreditCard(
//                                 onSuccess: () {},
//                                 onError: (code, message) {
//                                   Helper.showErrorDialog(
//                                       context: context,
//                                       message: message,
//                                       code: code,
//                                       onPressPrimaryButton: () {});
//                                 },
//                                 body: body));
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             )));
//       },
//     );
//   }
// }
