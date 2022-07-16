import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:plugin_helper/models/credit_card/credit_card_model.dart';
import 'package:plugin_helper/plugin_app_environment.dart';

class MyPluginPayment {
  static init() {
    Stripe.publishableKey = MyPluginAppEnvironment().stripePublicKey!;
  }

  static Future<String> createTokenWidthCreditCard(
      {required CreditCardModel data}) async {
    final CardDetails _card = CardDetails(
      cvc: data.cvvCode,
      expirationMonth: int.parse(data.expiryDate.split('/')[0]),
      expirationYear: int.parse(data.expiryDate.split('/')[1]),
      number: data.cardNumber,
    );
    await Stripe.instance.dangerouslyUpdateCardDetails(_card);
    final paymentMethod = await Stripe.instance
        .createPaymentMethod(const PaymentMethodParams.card(
      paymentMethodData: PaymentMethodData(billingDetails: null),
    ));
    return paymentMethod.id;
  }
}
