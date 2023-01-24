import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:teledart/teledart.dart';
import 'package:vpn_telegram_bot/loger.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/my_giga_button.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/my_giga_keyboard.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/my_giga_page.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/my_giga_text.dart';

import '../configurations.dart';
import 'dash-board.page.dart';
import 'rate.page.dart';
import 'test-period/test-period-choice-region.page.dart';

final mainMenuText = MyGigaText.string('''Привет!
VPNster в телеграм!
Простой в использовании VPN сервис.''');

final startMenu = MyGigaPage.withoutRegistration(
  name: 'main-menu',
  text: mainMenuText,
  renderMethod: (teleDart, pageMessage, user, text, markup) async {
    var response = await post(Uri.http(Configurations.backendHost, "/users"),
        body: jsonEncode({
          "telegramId": user.id.toString(),
          "username": user.username,
          "regionId": '4f4abb0b-063b-4a91-b944-acfbf68c3a1b'
        }));

    Loger.log('main-menu',
        userId: user.id.toString(),
        body: '/users status: ${response.statusCode}');

    MyGigaPage.send(teleDart, pageMessage, user, text, markup);
  },
);

final mainMenu = MyGigaPage(
  name: 'main-menu',
  text: mainMenuText,
  renderMethod: MyGigaPage.edit,
);

final testPeriodActivate = MyGigaPage(
  name: 'main-menu',
  text: mainMenuText,
  renderMethod: ((teleDart, message, user, text, markup) async {
    var response = await patch(Uri.http(
        Configurations.backendHost, "/users/${user.id}/useFreePeriod"));

    var teledart = GetIt.I<TeleDart>(); // TODO
    await teledart.editMessageReplyMarkup(
        chat_id: message.chat.id,
        message_id: message.message_id,
        reply_markup: null);

    try {
      response = await get(
          Uri.http(Configurations.backendHost, "/users/${user.id}/qrCode"));

      final photo = File('qr.png');
      photo.writeAsBytesSync(response.body.codeUnits);

      await MyGigaPage.sendPhoto(teleDart, message.chat.id, photo);
    } catch (exception, stacktrace) {
      Loger.log('TestPeriodactivate',
          userId: user.id.toString(),
          body: '${exception.toString()}\n${stacktrace.toString()}');
    }

    try {
      response = await get(
          Uri.http(Configurations.backendHost, "/users/${user.id}/config"));

      var configFileBody = jsonDecode(response.body)['configFile'];

      final file = File('config.conf');
      file.writeAsStringSync(configFileBody);

      await MyGigaPage.sendFile(teleDart, message.chat.id, file);
    } catch (exception, stacktrace) {
      Loger.log('TestPeriodactivate',
          userId: user.id.toString(),
          body: '${exception.toString()}\n${stacktrace.toString()}');
    }

    MyGigaPage.send(teleDart, message, user, text, markup);
  }),
);

final mainMenuFirsTry = [
  [
    MyGigaButton.openPage(
        text: 'Получить ВПН', key: testPeriodChoiceRegion.getKey())
  ],
  [MyGigaButton.openPage(text: 'Тарифы', key: rate.getKey())],
  [
    MyGigaButton.openPage(text: 'Личный кабинет', key: dashBoard.getKey()),
  ]
];

final mainMenuUsualEntry = [
  [MyGigaButton.openPage(text: 'Тарифы', key: rate.getKey())],
  [MyGigaButton.openPage(text: 'Личный кабинет', key: dashBoard.getKey())]
];

late final mainMenuKeyboard =
    MyGigaKeybord.function(((pageMessage, user) async {
  var response =
      await get(Uri.http(Configurations.backendHost, "/users/${user.id}"));

  var responseBody = jsonDecode(response.body);
  final freePeriodUsed = responseBody['freePeriodUsed'].toString();

  return freePeriodUsed == 'true' ? mainMenuUsualEntry : mainMenuFirsTry;
}));

void mainKeyboard() {
  startMenu.changeKeyboard(mainMenuKeyboard);
  mainMenu.changeKeyboard(mainMenuKeyboard);
  testPeriodActivate.changeKeyboard(MyGigaKeybord.list(mainMenuUsualEntry));
}
