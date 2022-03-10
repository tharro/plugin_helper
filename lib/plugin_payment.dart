import 'package:plugin_helper/plugin_app_config.dart';
import 'package:plugin_helper/widgets/credit_card/flutter_credit_card.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PluginPayment {
  static init() {
    StripePayment.setOptions(StripeOptions(
      publishableKey: PluginAppConfig().stripePublicKey,
      merchantId: PluginAppConfig().merchantId,
      androidPayMode: PluginAppConfig().appEnvironment == AppEnvironment.prod
          ? 'production'
          : 'test',
    ));
  }

  static Future<String> addBankAccount(
      {required String countryCode,
      required String accountHolderName,
      required String routingNumber,
      required String accountNumber,
      required String currency}) async {
    var token = await StripePayment.createTokenWithBankAccount(
      BankAccount(
          countryCode: countryCode,
          accountHolderName: accountHolderName,
          routingNumber: routingNumber,
          accountNumber: accountNumber,
          currency: currency,
          accountHolderType: 'Individual'),
    );
    return token.tokenId!;
  }

  static Future<String> createTokenWidthCreditCard(
      {required CreditCardModel data}) async {
    final payment =
        await StripePayment.createPaymentMethod(PaymentMethodRequest(
            card: CreditCard(
      expMonth: int.parse(data.expiryDate.split('/')[0]),
      cvc: data.cvvCode,
      expYear: int.parse(data.expiryDate.split('/')[1]),
      number: data.cardNumber,
      name: data.cardHolderName,
    )));
    return payment.id!;
  }
}
