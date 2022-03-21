import 'package:flutter/material.dart';
import 'package:plugin_helper/widgets/credit_card/flutter_credit_card.dart';
import 'package:plugin_helper/widgets/credit_card/localized_text_model.dart';

class MyWidgetAddCreditCard extends StatefulWidget {
  final TextStyle textStyle;
  final InputDecoration? cardNumberDecorationCustom,
      expiryDateDecorationCustom,
      cvvCodeDecorationCustom;
  final String? cardNumberLabel, expiryDateLabel, cvvLabel;
  final TextStyle? labelStyle;
  final Color? inputColor, inputErrorColor;
  final Widget? buttonWidget;
  final String? cardNumber, cvvCode, expiryDate;
  final GlobalKey<FormState> formKey;
  final Function(CreditCardModel) onCreditCardModelChange;
  const MyWidgetAddCreditCard(
      {Key? key,
      required this.textStyle,
      this.cardNumberDecorationCustom,
      this.cardNumberLabel,
      this.expiryDateLabel,
      this.cvvLabel,
      this.labelStyle,
      this.inputColor,
      this.inputErrorColor,
      this.expiryDateDecorationCustom,
      this.cvvCodeDecorationCustom,
      this.buttonWidget,
      this.cardNumber = '',
      this.cvvCode = '',
      this.expiryDate = '',
      required this.formKey,
      required this.onCreditCardModelChange})
      : super(key: key);

  @override
  State<MyWidgetAddCreditCard> createState() => MyWidgetAddCreditCardState();
}

class MyWidgetAddCreditCardState extends State<MyWidgetAddCreditCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreditCardForm(
          formKey: widget.formKey,
          onCreditCardModelChange: (CreditCardModel data) {
            widget.onCreditCardModelChange(data);
          },
          themeColor: Colors.transparent,
          obscureCvv: false,
          obscureNumber: false,
          cardNumberDecoration: widget.cardNumberDecorationCustom ??
              inputBorder(
                  context: context,
                  title: widget.cardNumberLabel ??
                      const LocalizedText().cardNumberLabel),
          expiryDateDecoration: widget.expiryDateDecorationCustom ??
              inputBorder(
                  context: context,
                  title: widget.expiryDateLabel ??
                      const LocalizedText().expiryDateLabel),
          cvvCodeDecoration: widget.cvvCodeDecorationCustom ??
              inputBorder(
                  context: context,
                  title: widget.cvvLabel ?? const LocalizedText().cvvLabel),
          cardNumber: widget.cardNumber!,
          cvvCode: widget.cvvCode!,
          expiryDate: widget.expiryDate!,
          textStyle: widget.textStyle,
        ),
        const SizedBox(height: 15),
        widget.buttonWidget ?? Container()
      ],
    );
  }

  InputDecoration inputBorder({BuildContext? context, required String title}) =>
      InputDecoration(
        labelStyle: widget.labelStyle ??
            const TextStyle(fontSize: 18, color: Color(0xff6E6E81)),
        labelText: title,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: widget.inputColor ?? const Color(0xffE2E1E7))),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: widget.inputColor ?? const Color(0xffE2E1E7))),
        focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: widget.inputErrorColor ?? const Color(0xffFD4646))),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: widget.inputErrorColor ?? const Color(0xffFD4646))),
      );
}
