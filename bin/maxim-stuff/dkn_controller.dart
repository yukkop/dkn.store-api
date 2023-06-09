import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:vpn_telegram_bot/loger.dart';

import '../controlers/controller_interface.dart';
import 'callgear_requests.dart';

class DknController extends IController {
  DknController({required super.router});

  @override
  DknController addHandlers() {
    router
      ..get('/getNumbersList', _getNumbersList)
      ..get('/getIdsList', _getIdsList)
      ..post('/postBankNotification', _postBankNotification);

    return this;
  }

  Future<Response> _getNumbersList(Request request) async {
    var body = jsonEncode(await getManagersNumberList());
    print(body);

    return Response.ok(
      body,
    );
  }

  Future<Response> _getIdsList(Request request) async {
    var body = jsonEncode(await getManagersIdList());
    print(body);
    return Response.ok(
      body,
    );
  }

  Future<Response> _postBankNotification(Request request) async {
    var body = jsonEncode(await request.readAsString());
    print(body);
    Loger.log(request.headers.toString(), body: body);
    return Response.ok(
      body,
    );
  }
}
