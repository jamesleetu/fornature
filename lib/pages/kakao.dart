import 'dart:convert';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';

class KakaoAPI extends StatefulWidget {
  @override
  _KakaoAPIState createState() => _KakaoAPIState();
}

class _KakaoAPIState extends State<KakaoAPI> {
  final _URL = 'http://127.0.0.1:3000';
  final _ADMIN_KEY = 'a1a9e22984154bd8ca92bee9a5c0dd79';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        leading: IconButton(
          icon: Icon(Feather.x),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        title: Text('카카오 페이'),
        centerTitle: true,
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () async{
          var url = Uri.parse('https://kapi.kakao.com/v1/payment/ready');
           var res = await http.post(url,
             encoding: Encoding.getByName('utf8'),
             headers: {
              'Authorization' : 'KakaoAK $_ADMIN_KEY'
             },
             body: {
               'cid':'TC0ONETIME',
               'partner_order_id':'partner_order_id',
               'partner_user_id':'partner_user_id',
                'item_name' : '초코빠이',
               'quantity': '1',
               'total_amount':'22222',
               'vat_amount' : '2222',
               'tax_free_amount' : '0',
               'approval_url' : '$_URL/kakaopayment',
               'fail_url' : '$_URL/kakaopayment',
               'cancel_url': '$_URL/kakaopayment'
             }
           );
            Map<String, dynamic> result = json.decode(res.body);
            AndroidIntent intent = AndroidIntent(
              action: 'action_view',
              data: result['next_redirect_mobile_url'],
              arguments: {'txn_id': result['tid']},
            );
            await intent.launch();
          },
          child: Text("KakaoPay" ),
        ),
      ),
    );
  }
}