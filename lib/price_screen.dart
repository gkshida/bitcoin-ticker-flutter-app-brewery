import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bitcoin_ticker/constants.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'components/crypto_card.dart';
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
            padding: kPricePadding,
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
            height: kPriceContainerHeight,
            alignment: Alignment.center,
            padding: kPriceContainerPadding,
            color: Colors.lightBlue,
            child:
                Platform.isIOS ? _buildPickerItems() : _buildDropDownButton(),
          ),
        ],
      ),
    );
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
}
