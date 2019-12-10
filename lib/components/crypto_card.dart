import 'package:bitcoin_ticker/constants.dart';
import 'package:flutter/material.dart';

class CryptoCard extends StatelessWidget {
  final String crypto;
  final String convertedValue;
  final String selectedCurrency;

  CryptoCard({this.crypto, this.convertedValue, this.selectedCurrency});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: kCryptoCardMargin,
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: kCryptoCardChildPadding,
        child: Text(
          '1 $crypto = $convertedValue $selectedCurrency',
          textAlign: TextAlign.center,
          style: kCryptoCardChildTextStyle,
        ),
      ),
    );
  }
}