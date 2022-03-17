import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:plugin_helper/plugin_app_config.dart';
import 'package:plugin_helper/widgets/credit_card/flutter_credit_card.dart';

class PluginPayment {
  static init() {
    Stripe.publishableKey = PluginAppConfig().stripePublicKey!;
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
        .createPaymentMethod(const PaymentMethodParams.card());
    return paymentMethod.id;
  }
}
