// import '../../configs/app_text_styles.dart';
// import '../../widgets/button_custom.dart';
// import 'package:flutter/material.dart';
// import 'package:plugin_helper/widgets/credit_card/credit_card_model.dart';
// import 'package:plugin_helper/widgets/credit_card/widget_add_credit_card.dart';
// import 'package:easy_localization/easy_localization.dart';

// class CreditCardCustom extends StatefulWidget {
//   final Function(CreditCardModel) onPress;
//   final GlobalKey<FormState> formKey;
//   const CreditCardCustom(
//       {Key? key, required this.onPress, required this.formKey})
//       : super(key: key);

//   @override
//   State<CreditCardCustom> createState() => _CreditCardCustomState();
// }

// class _CreditCardCustomState extends State<CreditCardCustom> {
//   late CreditCardModel _card;
//   @override
//   Widget build(BuildContext context) {
//     return MyWidgetAddCreditCard(
//       formKey: widget.formKey,
//       buttonWidget: ButtonCustom(
//           title: 'key_add_card'.tr(),
//           onPressed: () {
//             widget.onPress(_card);
//           }),
//       textStyle: AppTextStyles.textSize12(),
//       onCreditCardModelChange: (CreditCardModel data) {
//         _card = data;
//       },
//     );
//   }
// }
