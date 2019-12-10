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
  String convertedValueBtc = '?';
  String convertedValueEth = '?';
  String convertedValueLtc = '?';

  void _getCoinDatas() async {
    List<dynamic> coinDatas = await CoinData().getCoinData(selectedCurrency);

    setState(() {
      if (coinDatas == null) {
        return;
      }
      convertedValueBtc = coinDatas[0]['last'].toString();
      convertedValueEth = coinDatas[1]['last'].toString();
      convertedValueLtc = coinDatas[2]['last'].toString();
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
          convertedValueBtc = '?';
          convertedValueEth = '?';
          convertedValueLtc = '?';
          _getCoinDatas();
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
        _getCoinDatas();
      },
      children: items,
    );
  }

  @override
  void initState() {
    super.initState();
    _getCoinDatas();
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
              children: [
                CryptoCard(
                  crypto: cryptoList[0],
                  convertedValue: convertedValueBtc,
                  selectedCurrency: selectedCurrency,
                ),
                CryptoCard(
                  crypto: cryptoList[1],
                  convertedValue: convertedValueEth,
                  selectedCurrency: selectedCurrency,
                ),
                CryptoCard(
                  crypto: cryptoList[2],
                  convertedValue: convertedValueLtc,
                  selectedCurrency: selectedCurrency,
                ),
              ],
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

class CryptoCard extends StatelessWidget {
  final String crypto;
  final String convertedValue;
  final String selectedCurrency;

  CryptoCard({this.crypto, this.convertedValue, this.selectedCurrency});

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
