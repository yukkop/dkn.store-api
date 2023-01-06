import 'package:get_it/get_it.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:vpn_telegram_bot/callback_data.dart';
import 'package:vpn_telegram_bot/data/interfaces/dialog.data_source.interface.dart';
import 'package:vpn_telegram_bot/data/layout.enum.dart';
import 'package:vpn_telegram_bot/page.enum.dart';
import 'package:vpn_telegram_bot/pages/interfaces/page.interface.dart';

class FirstMenuPage extends BasePage {
  @override
  TeleDart get teledart => GetIt.I<TeleDart>();
  @override
  DialogDataSourceInterface get dialogDataSource =>
      GetIt.I<DialogDataSourceInterface>();

  String get separator => dialogDataSource.separator;
  @override
  String get name => PageEnum.first_menu.name;
  @override
  String get path =>
      'intro${separator}start${separator}terms_of_use${separator}first_menu';
  @override
  void register() {
    teledart.onCallbackQuery().listen((event) {
      final data = CallbackData.fromJson(event.data ?? "pg: unnown");
      final page = data.pg;

      if (page == name) {
        if (data.prms == null) {
          // TODO throw
          return;
        }

        final Param? region =
            data.prms?.firstWhere((element) => element.n == 'region');
        if (data.prms == null) {
          // TODO throw
          return;
        }
        inlineKeyboardMarkup = InlineKeyboardMarkup(inline_keyboard: [
          [
            InlineKeyboardButton(
                text:
                    dialogDataSource.getButtonText(path, 'test', LayoutEnum.ru),
                callback_data:
                    CallbackData(pg: PageEnum.terms_of_use_denial.name)
                        .toJson()),
            InlineKeyboardButton(
                text:
                    dialogDataSource.getButtonText(path, 'pay', LayoutEnum.ru),
                callback_data:
                    CallbackData(pg: PageEnum.first_menu.name).toJson())
          ]
        ]);

        render(
            chatId: event.message?.chat.id,
            renderMethod: (int chatId, String text) {
              edit(chatId, text, event.message?.message_id);
            },
            textValues: [(region as Param).v]);
      }
    });
  }
}