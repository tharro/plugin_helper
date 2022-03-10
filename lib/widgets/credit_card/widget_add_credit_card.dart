import 'package:flutter/material.dart';
import 'package:plugin_helper/plugin_payment.dart';
import 'package:plugin_helper/widgets/credit_card/credit_card_form.dart';
import 'package:plugin_helper/widgets/credit_card/flutter_credit_card.dart';
import 'package:plugin_helper/widgets/credit_card/localized_text_model.dart';
import 'package:plugin_helper/widgets/widget_button_custom.dart';

class WidgetAddCreditCard extends StatefulWidget {
  final TextStyle textStyle;
  final InputDecoration? cardNumberDecorationCustom,
      expiryDateDecorationCustom,
      cvvCodeDecorationCustom,
      cardHolderDecorationCustom;
  final String? cardNumberLabel, expiryDateLabel, cvvLabel, cardHolderLabel;
  final TextStyle? labelStyle;
  final Color? inputColor, inputErrorColor;
  final Function onCreateToken;
  final Widget? buttonWidget;
  const WidgetAddCreditCard(
      {Key? key,
      required this.textStyle,
      this.cardNumberDecorationCustom,
      this.cardNumberLabel,
      this.expiryDateLabel,
      this.cvvLabel,
      this.cardHolderLabel,
      this.labelStyle,
      this.inputColor,
      this.inputErrorColor,
      this.expiryDateDecorationCustom,
      this.cvvCodeDecorationCustom,
      this.cardHolderDecorationCustom,
      required this.onCreateToken,
      this.buttonWidget})
      : super(key: key);

  @override
  State<WidgetAddCreditCard> createState() => WidgetAddCreditCardState();
}

class WidgetAddCreditCardState extends State<WidgetAddCreditCard> {
  GlobalKey<FormState> formKey = GlobalKey();
  late CreditCardModel card;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreditCardForm(
          formKey: formKey,
          onCreditCardModelChange: (CreditCardModel data) {
            card = data;
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
          cardHolderDecoration: widget.cardHolderDecorationCustom ??
              inputBorder(
                  context: context,
                  title: widget.cardHolderLabel ??
                      const LocalizedText().cardHolderLabel),
          cardHolderName: '',
          cardNumber: '',
          cvvCode: '',
          expiryDate: '',
          textStyle: widget.textStyle,
        ),
        const SizedBox(height: 15),
        widget.buttonWidget ?? button()
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

  Widget button() {
    return WidgetButtonCustom(
      onPressed: () async {
        addCreditCard();
      },
      title: 'Add card',
    );
  }

  addCreditCard() async {
    if (formKey.currentState!.validate()) {
      String token = await PluginPayment.createTokenWidthCreditCard(data: card);
      widget.onCreateToken(token);
    }
  }
}
