import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'credit_card_model.dart';
import 'flutter_credit_card.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key? key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    this.obscureCvv = false,
    this.obscureNumber = false,
    required this.onCreditCardModelChange,
    required this.themeColor,
    required this.textStyle,
    this.cursorColor,
    this.cardHolderDecoration = const InputDecoration(
      labelText: 'Card holder',
    ),
    this.cardNumberDecoration = const InputDecoration(
      labelText: 'Card number',
      hintText: 'XXX XXXXX XXXX XXXX',
    ),
    this.expiryDateDecoration = const InputDecoration(
      labelText: 'Expired Date',
      hintText: 'MM/YY',
    ),
    this.cvvCodeDecoration = const InputDecoration(
      labelText: 'CVV',
      hintText: 'XXX',
    ),
    required this.formKey,
    this.cvvValidationMessage = 'Please input a valid CVV',
    this.dateValidationMessage = 'Please input a valid date',
    this.numberValidationMessage = 'Please input a valid number',
  }) : super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final String cvvValidationMessage;
  final String dateValidationMessage;
  final String numberValidationMessage;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color themeColor;
  final TextStyle textStyle;
  final Color? cursorColor;
  final bool obscureCvv;
  final bool obscureNumber;
  final GlobalKey<FormState> formKey;

  final InputDecoration cardNumberDecoration;
  final InputDecoration cardHolderDecoration;
  final InputDecoration expiryDateDecoration;
  final InputDecoration cvvCodeDecoration;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  late String cardNumber;
  late String expiryDate;
  late String cardHolderName;
  late String cvvCode;
  bool isCvvFocused = false;
  late Color themeColor;

  late void Function(CreditCardModel) onCreditCardModelChange;
  late CreditCardModel creditCardModel;

  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();
  FocusNode cardNumberNode = FocusNode();
  FocusNode expiryDateNode = FocusNode();
  FocusNode cardHolderNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber;
    expiryDate = widget.expiryDate;
    cardHolderName = widget.cardHolderName;
    cvvCode = widget.cvvCode;

    creditCardModel = CreditCardModel(
        cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel);
      });
    });
  }

  @override
  void dispose() {
    cardHolderNode.dispose();
    cvvFocusNode.dispose();
    expiryDateNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor;
    super.didChangeDependencies();
  }

  /// This function determines the Credit Card type based on the cardPatterns
  /// and returns it.
  bool isAmex = false;
  Map<CardType, Set<List<String>>> cardNumPatterns =
      <CardType, Set<List<String>>>{
    CardType.visa: <List<String>>{
      <String>['4'],
    },
    CardType.americanExpress: <List<String>>{
      <String>['34'],
      <String>['37'],
    },
    CardType.discover: <List<String>>{
      <String>['6011'],
      <String>['622126', '622925'],
      <String>['644', '649'],
      <String>['65']
    },
    CardType.mastercard: <List<String>>{
      <String>['51', '55'],
      <String>['2221', '2229'],
      <String>['223', '229'],
      <String>['23', '26'],
      <String>['270', '271'],
      <String>['2720'],
    },
  };

  CardType detectCCType(String cardNumber) {
    //Default card type is other
    CardType cardType = CardType.otherBrand;

    if (cardNumber.isEmpty) {
      return cardType;
    }

    cardNumPatterns.forEach(
      (CardType type, Set<List<String>> patterns) {
        for (List<String> patternRange in patterns) {
          // Remove any spaces
          String ccPatternStr =
              cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
          final int rangeLen = patternRange[0].length;
          // Trim the Credit Card number string to match the pattern prefix length
          if (rangeLen < cardNumber.length) {
            ccPatternStr = ccPatternStr.substring(0, rangeLen);
          }

          if (patternRange.length > 1) {
            // Convert the prefix range into numbers then make sure the
            // Credit Card num is in the pattern range.
            // Because Strings don't have '>=' type operators
            final int ccPrefixAsInt = int.parse(ccPatternStr);
            final int startPatternPrefixAsInt = int.parse(patternRange[0]);
            final int endPatternPrefixAsInt = int.parse(patternRange[1]);
            if (ccPrefixAsInt >= startPatternPrefixAsInt &&
                ccPrefixAsInt <= endPatternPrefixAsInt) {
              // Found a match
              cardType = type;
              break;
            }
          } else {
            // Just compare the single pattern prefix with the Credit Card prefix
            if (ccPatternStr == patternRange[0]) {
              // Found a match
              cardType = type;
              break;
            }
          }
        }
      },
    );

    return cardType;
  }

  // This method returns the icon for the visa card type if found
  // else will return the empty container
  Widget? getCardTypeIcon(String cardNumber) {
    Widget? icon;
    switch (detectCCType(cardNumber)) {
      case CardType.visa:
        icon = Image.asset(
          'assets/icons/visa.png',
          height: 26,
          width: 45,
          package: 'plugin_helper',
          fit: BoxFit.fill,
        );
        isAmex = false;

        break;

      case CardType.americanExpress:
        icon = Image.asset(
          'assets/icons/amex.png',
          height: 26,
          width: 45,
          package: 'plugin_helper',
          fit: BoxFit.fill,
        );
        isAmex = true;
        break;

      case CardType.mastercard:
        icon = Image.asset(
          'assets/icons/mastercard.png',
          height: 26,
          width: 45,
          package: 'plugin_helper',
          fit: BoxFit.fill,
        );
        isAmex = false;
        break;

      case CardType.discover:
        icon = Image.asset(
          'assets/icons/discover.png',
          height: 26,
          width: 45,
          package: 'plugin_helper',
          fit: BoxFit.fill,
        );
        isAmex = false;
        break;

      default:
        isAmex = false;
        break;
    }

    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextFormField(
                controller: _cardHolderNameController,
                cursorColor: widget.cursorColor ?? themeColor,
                focusNode: cardHolderNode,
                style: widget.textStyle,
                decoration: widget.cardHolderDecoration,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  onCreditCardModelChange(creditCardModel);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: TextFormField(
                    obscureText: widget.obscureNumber,
                    controller: _cardNumberController,
                    cursorColor: widget.cursorColor ?? themeColor,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(expiryDateNode);
                    },
                    style: widget.textStyle,
                    decoration: widget.cardNumberDecoration,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (String? value) {
                      // Validate less that 13 digits +3 white spaces
                      if (value!.isEmpty || value.length < 16) {
                        return widget.numberValidationMessage;
                      }
                      return null;
                    },
                  )),
                  const SizedBox(width: 6),
                  if (getCardTypeIcon(_cardNumberController.text) != null)
                    getCardTypeIcon(_cardNumberController.text)!,
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: _expiryDateController,
                    cursorColor: widget.cursorColor ?? themeColor,
                    focusNode: expiryDateNode,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(cvvFocusNode);
                    },
                    style: widget.textStyle,
                    decoration: widget.expiryDateDecoration,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return widget.dateValidationMessage;
                      }

                      final DateTime now = DateTime.now();
                      final List<String> date = value.split(RegExp(r'/'));
                      final int month = int.parse(date.first);
                      final int year = int.parse('20${date.last}');
                      final DateTime cardDate = DateTime(year, month);

                      if (cardDate.isBefore(now) || month > 12 || month == 0) {
                        return widget.dateValidationMessage;
                      }
                      return null;
                    },
                  )),
                  const SizedBox(width: 6),
                  Expanded(
                      child: TextFormField(
                    obscureText: widget.obscureCvv,
                    focusNode: cvvFocusNode,
                    controller: _cvvCodeController,
                    cursorColor: widget.cursorColor ?? themeColor,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(cardHolderNode);
                    },
                    style: widget.textStyle,
                    decoration: widget.cvvCodeDecoration,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (String text) {
                      setState(() {
                        cvvCode = text;
                      });
                    },
                    validator: (String? value) {
                      if (value!.isEmpty || value.length < 3) {
                        return widget.cvvValidationMessage;
                      }
                      return null;
                    },
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
