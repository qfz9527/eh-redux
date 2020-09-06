import 'package:eh_redux/database/database.dart';
import 'package:eh_redux/generated/l10n.dart';
import 'package:eh_redux/modules/setting/store.dart';
import 'package:eh_redux/modules/setting/types.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:provider/provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'confirm_list_tile.dart';
import 'select_list_tile.dart';

part 'screen.g.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key key}) : super(key: key);

  static const route = '/setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settingScreenTitle),
      ),
      body: const SafeArea(
        child: _Body(),
      ),
    );
  }
}

@swidget
Widget _body(BuildContext context) {
  final settingStore = Provider.of<SettingStore>(context);
  final database = Provider.of<Database>(context);

  return ListView(
    children: [
      _Title(S.of(context).settingSectionAppearance),
      _SelectTile(
        title: S.of(context).settingTheme,
        preference: settingStore.theme,
        items: [
          DropdownMenuItem(
            value: ThemeSetting.system,
            child: Text(S.of(context).settingThemeSystem),
          ),
          DropdownMenuItem(
            value: ThemeSetting.light,
            child: Text(S.of(context).settingThemeLight),
          ),
          DropdownMenuItem(
            value: ThemeSetting.dark,
            child: Text(S.of(context).settingThemeDark),
          ),
          DropdownMenuItem(
            value: ThemeSetting.black,
            child: Text(S.of(context).settingThemeBlack),
          ),
        ],
      ),
      const Divider(),
      _Title(S.of(context).settingSectionGalleryList),
      _SwitchTile(
        title: S.of(context).settingDisplayJapaneseTitle,
        preference: settingStore.displayJapaneseTitle,
      ),
      ConfirmListTile(
        title: Text(S.of(context).settingClearReadingHistory),
        dialogTitle: Text(S.of(context).clearReadingHistoryDialogTitle),
        dialogContent: Text(S.of(context).clearReadingHistoryDialogContent),
        confirmActionChild: Text(S.of(context).clearButtonLabel),
        onConfirm: () async {
          await database.historyDao.deleteAll();

          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).readingHistoryClearSuccess),
          ));
        },
      ),
      const Divider(),
      _Title(S.of(context).settingSectionImageView),
      _SelectTile<OrientationSetting>(
        title: S.of(context).settingScreenOrientation,
        preference: settingStore.orientation,
        items: [
          DropdownMenuItem(
            value: OrientationSetting.auto,
            child: Text(S.of(context).settingScreenOrientationAuto),
          ),
          DropdownMenuItem(
            value: OrientationSetting.portrait,
            child: Text(S.of(context).settingScreenOrientationPortrait),
          ),
          DropdownMenuItem(
            value: OrientationSetting.landscape,
            child: Text(S.of(context).settingScreenOrientationLandscape),
          ),
        ],
      ),
      _SwitchTile(
        title: S.of(context).settingTurnPagesWithVolumeKeys,
        preference: settingStore.turnPagesWithVolumeKeys,
      ),
      const Divider(),
      _Title(S.of(context).settingSectionSearch),
      ConfirmListTile(
        title: Text(S.of(context).settingClearSearchHistory),
        dialogTitle: Text(S.of(context).clearSearchHistoryDialogTitle),
        dialogContent: Text(S.of(context).clearSearchHistoryDialogContent),
        confirmActionChild: Text(S.of(context).clearButtonLabel),
        onConfirm: () async {
          await database.searchHistoriesDao.deleteAllEntries();

          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).searchHistoryClearSuccess),
          ));
        },
      ),
    ],
  );
}

@swidget
Widget _title(BuildContext context, String title) {
  final theme = Theme.of(context);

  return ListTile(
    title: Text(
      title,
      style: theme.textTheme.bodyText1
          .copyWith(color: theme.textTheme.caption.color),
    ),
  );
}

@swidget
Widget _selectTile<T>(
  BuildContext context, {
  @required String title,
  @required Preference<T> preference,
  @required List<DropdownMenuItem<T>> items,
}) {
  return PreferenceBuilder<T>(
    preference: preference,
    builder: (context, value) => SelectListTile<T>(
      title: Text(title),
      items: items,
      onChanged: preference.setValue,
      value: value,
    ),
  );
}

@swidget
Widget _switchTile(
  BuildContext context, {
  @required String title,
  @required Preference<bool> preference,
}) {
  return PreferenceBuilder<bool>(
    preference: preference,
    builder: (context, value) => SwitchListTile.adaptive(
      title: Text(title),
      value: value,
      onChanged: preference.setValue,
    ),
  );
}
