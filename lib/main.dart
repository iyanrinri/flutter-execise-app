import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing/services/api_service.dart';
import 'package:testing/utils/statics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'routes/routes.dart';
import 'package:testing/providers/auth_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (modApp == "prod") {
    await dotenv.load(fileName: ".env.prod");
  } else {
    await dotenv.load(fileName: ".env");
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aplikasi Antrian Digital',
        theme: ThemeData(primarySwatch: Colors.blue),
        routes: routes,
        builder: (context, child) {
          return SafeArea(
            child: child!, // Pastikan konten berada di dalam SafeArea
          );
        },
      ),
    );
  }
}
