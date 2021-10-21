import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http; 
import 'dart:async';

import 'package:test_app/models/entreprise.dart';


class  AllService{  

   Future<List<Entreprise>> getGameData(int id, String jwt) async {
     
    var url =Uri.https('', 'api/entreprise/entreprise/${id}/list');
    var client = http.Client(); 
    final response = await client.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    }); 
    try{
      if (response.statusCode == 200) {
        print("object TEST");
        final parsed = convert.json.decode(response.body).cast<Map<String, dynamic>>();
        
        return parsed.map<Entreprise>((json) => Entreprise.fromJson(json)).toList();
        
      } else {
        throw Exception("Failed to load Data");
      }
    }finally{
      client.close();
    }
  }
}