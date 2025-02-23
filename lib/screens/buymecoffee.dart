import 'package:flutter/material.dart';
import 'package:fireflutter/function/esewa.dart';
import 'package:lottie/lottie.dart';

class Buymecoffee extends StatefulWidget {
  const Buymecoffee({super.key});

  @override
  State<Buymecoffee> createState() => _BuymecoffeeState();
}

class _BuymecoffeeState extends State<Buymecoffee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Buy Me Coffee'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Wanna Contribute to the Developers?',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900]),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 400,
                  width: double.infinity,
                  child: Lottie.network(
                      'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json'),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(0, 50),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      Esewa esewa = Esewa();
                      esewa.pay();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        Image.asset(
                          'assets/images/esewa_logo.png',
                          height: 50,
                          width: 50,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Pay with eSewa'),
                        // Spacer(),
                      ]),
                    ))
              ],
            ),
          ),
        ));
  }
}
