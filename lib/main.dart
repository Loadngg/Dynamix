import 'package:dynamix/ui/chart/view_model/chart_viewmodel.dart';
import 'package:dynamix/ui/folders/view_model/folders_viewmodel.dart';
import 'package:dynamix/ui/folders/widgets/screen/folder_screen.dart';
import 'package:dynamix/ui/groups/view_model/groups_viewmodel.dart';
import 'package:dynamix/ui/reports/view_model/reports_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru_RU', null);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FoldersViewModel()),
        ChangeNotifierProvider(create: (context) => GroupsViewModel()),
        ChangeNotifierProvider(create: (context) => ReportsViewModel()),
        ChangeNotifierProvider(create: (context) => ChartViewModel()),
      ],
      child: const Application(),
    ),
  );
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    const Color seedColor = Colors.blue;
    const String title = 'Dynamix';

    return MaterialApp(
      locale: const Locale('ru', 'RU'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ru', 'RU')],
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
      ),
      home: const FolderScreen(),
    );
  }
}
