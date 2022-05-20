class CreditCardModel {
  CreditCardModel(this.cardNumber, this.cardHolder, this.expiryDate,
      this.cvvCode, this.isCvvFocused);

  String cardNumber = '';
  String cardHolder = '';
  String expiryDate = '';
  String cvvCode = '';
  String brand = '';
  bool isCvvFocused = false;
}
