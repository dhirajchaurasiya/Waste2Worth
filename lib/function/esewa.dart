import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:fireflutter/constant/esewaconst.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:esewa_flutter_sdk/payment_failure.dart';
import 'package:flutter/material.dart';

class Esewa {
  pay() {
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test,
          clientId: kCLIENT_ID,
          secretId: kSECRET_KEY,
        ),
        esewaPayment: EsewaPayment(
            productId: "1d71jd81",
            productName: "Product One",
            productPrice: "20",
            callbackUrl: "https://google.com"),
        onPaymentSuccess: (EsewaPaymentSuccessResult data) {
          debugPrint(":::SUCCESS::: => $data");
          verify(data);
          AlertBox();
          // verifyTransactionStatus(data);
        },
        onPaymentFailure: (data) {
          debugPrint(":::FAILURE::: => $data");
        },
        onPaymentCancellation: (data) {
          debugPrint(":::CANCELLATION::: => $data");
        },
      );
    } on Exception catch (e) {
      debugPrint("EXCEPTION : ${e.toString()}");
    }
  }

  verify(EsewaPaymentSuccessResult data) {
    //after success call this function
    print("success");
    AlertBox();
    print("calling alert box");
  }
}

class AlertBox extends StatefulWidget {
  const AlertBox({super.key});

  @override
  State<AlertBox> createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      child: AlertDialog(
        title: Text("Success"),
      ),
    );
  }
}
