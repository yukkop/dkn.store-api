import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:vpn_telegram_bot/loger.dart';

import 'configurations.dart';
import 'maxim-stuff/dkn_controller.dart';

final overrideHeaders = {
  "Access-Control-Allow-Origin": "*",
  'Access-Control-Allow-Methods': 'GET, POST, PATCH, PUT, DELETE',
  "Access-Control-Allow-Headers": "X-Requested-With",
};

Future<void> main() async {
  Loger.log('Program starting..');

  final router = Router();
  DknController(router: router).addHandlers();

  final ip = InternetAddress.anyIPv4;
  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders(headers: overrideHeaders))
      .addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? Configurations.port);
  final server = await serve(handler, ip, port);

  Loger.log('Server listening on port ${server.port}');
}
