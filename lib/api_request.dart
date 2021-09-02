import 'dart:convert';

import 'package:http/http.dart' as http;

class Request{
  void api() async
  {
    var client = http.Client();
    var data = await client.get(Uri.parse("https://thekrishi.com/test/mandi?lat=28.44108136&lon=77.0526054&ver=89&lang=hi&crop_id=10"));
    if (data.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonDecodes = jsonDecode(data.body);
      print(jsonDecodes);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}