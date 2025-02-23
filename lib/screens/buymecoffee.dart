import 'package:flutter/material.dart';
import 'package:fireflutter/function/esewa.dart';

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
        body: Column(
          children: [
            Text('Buy Me Coffee'),
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  Esewa esewa = Esewa();
                  esewa.pay();
                },
                child: Text('Buy Now with eSewa'))
          ],
        ));
  }
}
