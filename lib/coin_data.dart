import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const bitCoinAverageURL =
    'https://apiv2.bitcoinaverage.com/indices/global/ticker/';

class CoinData {
  List<Future<http.Response>> _buildCryptoFutures(String currency) {
    List<Future<http.Response>> futures = [];

    for (String crypto in cryptoList) {
      futures.add(http.get('$bitCoinAverageURL$crypto$currency'));
    }

    return futures;
  }

  Future<dynamic> getCoinData(String currency) async {
    List<dynamic> datas = [];

    var responses = await Future.wait(_buildCryptoFutures(currency));

    for (var response in responses) {
      String data = response.body;
      datas.add(jsonDecode(data));
    }

    return datas;
  }

}
