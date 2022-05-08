// import 'dart:convert';
// import 'dart:io';

// import '../../blocs/payment/bank/bank_bloc.dart';
// import '../../utils/helper.dart';
// import '../../widgets/button_custom.dart';
// import '../../widgets/overlay_loading_custom.dart';
// import '../../widgets/text_field_custom.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:plugin_helper/widgets/widget_text_field.dart';
// import 'package:easy_localization/easy_localization.dart';

// class PaymentBank extends StatefulWidget {
//   const PaymentBank({Key? key}) : super(key: key);

//   @override
//   State<PaymentBank> createState() => _PaymentBankState();
// }

// class _PaymentBankState extends State<PaymentBank> {
//   final TextEditingController _accountHolderController =
//       TextEditingController();

//   final TextEditingController _routingController = TextEditingController();
//   final TextEditingController _accountNumberController =
//       TextEditingController();
//   final FocusNode _accountHolderFocusNode = FocusNode();
//   final FocusNode _routingFocusNode = FocusNode();
//   final FocusNode _accountNumberFocusNode = FocusNode();
//   bool _isValidAccountHolder = false, _isValidAccountNumber = false;
//   List<dynamic> listCountriesWithCurrency = [];
//   String _countryCode = '', _currency = '';
//   @override
//   void initState() {
//     getCountryCode();
//     super.initState();
//   }

//   getCountryCode() async {
//     String _localeName = Platform.localeName;
//     _countryCode = _localeName.split('_').last;
//     String _data = await DefaultAssetBundle.of(context)
//         .loadString("assets/countries.json");
//     final result = jsonDecode(_data);
//     listCountriesWithCurrency = result['countries']['country'];
//     _currency = listCountriesWithCurrency.firstWhere(
//         (element) => element['countryCode'] == _countryCode)['currencyCode'];
//   }

//   _submit() async {
//     if (!_isValidAccountHolder || !_isValidAccountNumber) {
//       return;
//     }
//     Map<String, dynamic> body = {
//       'country_code': _countryCode,
//       'currency': _currency,
//       'account_number': _accountNumberController.text,
//       'routing_number': _routingController.text,
//       'account_holder_name': _accountHolderController.text,
//       'account_holder_type': 'Individual'
//     };
//     BlocProvider.of<BankBloc>(context).add(AddBank(
//         onSuccess: () {},
//         onError: (code, message) {
//           Helper.showErrorDialog(
//               context: context,
//               message: message,
//               code: code,
//               onPressPrimaryButton: () {});
//         },
//         body: body));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BankBloc, BankState>(
//       builder: (context, state) {
//         return OverlayLoadingCustom(
//             isLoading: state.addBankLoading!,
//             child: Scaffold(
//                 body: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   TextFieldCustom(
//                     controller: _accountHolderController,
//                     focusNode: _accountHolderFocusNode,
//                     validType: ValidType.notEmpty,
//                     hintText: 'key_account_holder_name'.tr(),
//                     onValid: (bool val) {
//                       _isValidAccountHolder = val;
//                     },
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   TextFieldCustom(
//                     controller: _accountNumberController,
//                     focusNode: _accountNumberFocusNode,
//                     validType: ValidType.notEmpty,
//                     keyboardType: TextInputType.number,
//                     hintText: 'key_account_number'.tr(),
//                     onValid: (bool val) {
//                       _isValidAccountNumber = val;
//                     },
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   TextFieldCustom(
//                     controller: _routingController,
//                     focusNode: _routingFocusNode,
//                     validType: ValidType.none,
//                     keyboardType: TextInputType.number,
//                     hintText: 'key_routing'.tr(),
//                     showError: false,
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   ButtonCustom(title: 'Add Bank', onPressed: _submit)
//                 ],
//               ),
//             )));
//       },
//     );
//   }
// }
