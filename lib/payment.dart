import 'package:flutter/material.dart';
import 'package:paystack_manager/models/transaction.dart';
import 'package:paystack_manager/paystack_pay_manager.dart';

class PaymentPage extends StatefulWidget {
  final String title;
  const PaymentPage({Key key, this.title = 'title'}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _processPayStackPayment,
          child: Text('Pay 500'),
        ),
      ),
    );
  }

// This payment method uses paystack payment to work
//it also uses the paystack manager package to process payment
// requests.
  /// this payment package doesn't support null safety.
  _processPayStackPayment() {
    try {
      PaystackPayManager(context: context)
        ..setSecretKey("{pk_test_45aea8d471920c74b987cbceabc430dcf50c4c90}")
        ..setAmount(50000)
        ..setReference(DateTime.now().millisecondsSinceEpoch.toString())
        ..setCurrency("NGN")
        ..setEmail("adolesamuel@yahoo.com")
        ..setFirstName("Adole")
        ..setLastName("Samuel")
        ..setMetadata(
          {
            "custom_fields": [
              {
                "value": "Test with Paystack", // set this your company name
                "display_name": "Payment_to",
                "variable_name": "Payment_to",
              }
            ]
          },
        )
        ..onSuccesful(_onPaymentSuccessful)
        ..onPending(_onPaymentPending)
        ..onFailed(_onPaymentFailed)
        ..onCancel(_onCancel)
        ..initialize();
    } catch (error) {
      print('Payment Error ==> $error');
    }
  }

  void _onPaymentSuccessful(Transaction trans) {
    print('Transaction successful');

    print(
        "Transaction message ==> ${trans.message} ,Ref ${trans.refrenceNumber}");
  }

  void _onPaymentPending(Transaction transaction) {
    print('Transaction Pending');
    print("Transaction Ref ${transaction.refrenceNumber}");
  }

  void _onPaymentFailed(Transaction transaction) {
    print('Transaction Failed');
    print("Transaction message ==> ${transaction.message}");
  }

  void _onCancel(Transaction transaction) {
    print('Transaction Cancelled');
  }
}
