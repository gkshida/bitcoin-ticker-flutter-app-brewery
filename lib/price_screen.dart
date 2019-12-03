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
  String btcUsdMessage = '1 BTC = ? USD';

  void _getCoinData() async {
    var coinData = await CoinData().getCoinData(selectedCurrency);
    double btcUsdValue;

    setState(() {
      if (coinData == null) {
        btcUsdMessage =  'Could not get data';
        return;
      }
      btcUsdValue = coinData['last'];
      btcUsdMessage =  '1 BTC = $btcUsdValue $selectedCurrency';
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
        print(index);
      },
      children: items,
    );
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
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  btcUsdMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
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
