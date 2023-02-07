import 'dart:convert';

import 'package:http/http.dart';
import 'package:vpn_telegram_bot/constants.dart';
import 'package:vpn_telegram_bot/data/layout.enum.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/button.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/keyboard.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../../configurations.dart';
import '../../variables.dart';
import '../main.page.dart';

final paidFor1Day = Page(
  name: 'Страница оплаты на 1 день',
  text: Text.function((pageMessage, user) async {
    return dialogDataSource.getMessage(
        'pay${dialogDataSource.separator}gratitude', LayoutEnum.ru);
  }),
  renderMethod: Page.send,
);

final paidFor1Week = Page(
  name: 'Страница оплаты на 1 неделя',
  text: Text.function((pageMessage, user) async {
    return dialogDataSource.getMessage(
        'pay${dialogDataSource.separator}gratitude', LayoutEnum.ru);
  }),
  renderMethod: Page.send,
);

final paidFor1Month = Page(
  name: 'Страница оплаты на 1 месяц',
  text: Text.function((pageMessage, user) async {
    return dialogDataSource.getMessage(
        'pay${dialogDataSource.separator}gratitude', LayoutEnum.ru);
  }),
  renderMethod: Page.send,
);

final paidFor1Year = Page(
  name: 'Страница оплаты на 1 год',
  text: Text.function((pageMessage, user) async {
    return dialogDataSource.getMessage(
        'pay${dialogDataSource.separator}gratitude', LayoutEnum.ru);
    ;
  }),
  renderMethod: Page.send,
);
