import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:justeasy/helpers/text_style.dart';
import 'package:justeasy/models/local_notification.dart';
import 'package:justeasy/routes/app_routes.dart';
import 'package:justeasy/routes/route_names.dart';
import 'package:justeasy/screen/connection_request.dart';
import 'package:justeasy/screen/splash/splash.dart';
import 'package:justeasy/services/background_services.dart';

void main() async{
  LicenseRegistry.addLicense(() async* {
    // final latoLicense = await rootBundle.loadString('google_fonts/Lato/OFL.txt');
    // yield LicenseEntryWithLineBreaks(['google_fonts'], latoLicense);
    // final eastSeaDokdoLicense1 = await rootBundle.loadString('google_fonts/EastSeaDokdo/OFL.txt');
    // yield LicenseEntryWithLineBreaks(['google_fonts'], eastSeaDokdoLicense1);
    // final notoLicense = await rootBundle.loadString('google_fonts/Noto/LICENSE.txt');
    // yield LicenseEntryWithLineBreaks(['google_fonts'], notoLicense);
    // final openSansLicense = await rootBundle.loadString('google_fonts/OpenSans/LICENSE.txt');
    // yield LicenseEntryWithLineBreaks(['google_fonts'], openSansLicense);
    final poppinsLicense = await rootBundle.loadString('google_fonts/Poppins/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], poppinsLicense);

    final alluraLicense = await rootBundle.loadString('google_fonts/allura/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], alluraLicense);

    final robotoLicense = await rootBundle.loadString('google_fonts/roboto/LICENSE.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], robotoLicense);

    final epilogueLicense = await rootBundle.loadString('google_fonts/epilogue/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], epilogueLicense);

    final PTSansLicense = await rootBundle.loadString('google_fonts/ptsans/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], PTSansLicense);
    // final ralewayLicense = await rootBundle.loadString('google_fonts/Raleway/OFL.txt');
    // yield LicenseEntryWithLineBreaks(['google_fonts'], ralewayLicense);
    // final robotoLicense = await rootBundle.loadString('google_fonts/Roboto/LICENSE.txt');
    // yield LicenseEntryWithLineBreaks(['google_fonts'], robotoLicense);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // DataManager.notifyOrganizer = LocalNotification(context: context);
    return ScreenUtilInit(
      designSize: Size(360, 689),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:() => MaterialApp(
      title: 'Just Easy',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        textTheme: AppTextStyle.getTextTheme(context),
      ),
      routes: AppRoutes.getRoutes(),
      initialRoute: AppRouteName.splash,
      builder: (context, widget){
         return MediaQuery(
          //Setting font does not change with system font size
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: widget!,
        );
      },
      // home: const SafeArea(
      //   // child: ConnectionRequestScreen(),
      //   child: Splash(),
      // ),
    )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
