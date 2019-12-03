import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String convertedValue = '?';

  void _getCoinData() async {
    var coinData = await CoinData().getCoinData(selectedCurrency);

    setState(() {
      if (coinData == null) {
        return;
      }
      convertedValue = coinData['last'].toString();
    });
  }

  DropdownButton<String> _buildDropDownButton() {
    List<DropdownMenuItem<String>> items = [];

    for (String currency in currenciesList) {
      items.add(
        DropdownMenuItem(
          child: Text(currency),
          value: currency,
        ),
      );
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: items,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          convertedValue = '?';
          _getCoinData();
        });
      },
    );
  }

  CupertinoPicker _buildPickerItems() {
    List<Text> items = [];

    for (String currency in currenciesList) {
      items.add(
        Text(currency),
      );
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (index) {
        selectedCurrency = currenciesList[index];
        _getCoinData();
      },
      children: items,
    );
  }

  List<Card> _buildCryptoCards() {
    List<Card> cryptoCards = [];

    for (String crypto in cryptoList) {
      cryptoCards.add(
        Card(
          margin: EdgeInsets.only(bottom: 18.0),
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 $crypto = $convertedValue $selectedCurrency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    return cryptoCards;
  }

  @override
  void initState() {
    super.initState();
    _getCoinData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildCryptoCards(),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:
                Platform.isIOS ? _buildPickerItems() : _buildDropDownButton(),
          ),
        ],
      ),
    );
  }
}
