// @dart=2.9
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final databaseReference = FirebaseDatabase.instance.reference();

  AnimationController progressController;
  Animation<double> tempAnimation;
  Animation<double> humidityAnimation;
  Animation<double> pressureAnimation;

  @override
  void initState() {
    super.initState();

    databaseReference
        .child('temphum')
        .once().then((event) {
      dynamic dataSnapshot = event.snapshot;
      dynamic temp =
          double.parse((dataSnapshot.value['tem']['Data']).toString());
      dynamic humidity =
          double.parse((dataSnapshot.value['hum']['Data']).toString());
      dynamic pressure =
          double.parse((dataSnapshot.value['bar']['Data']).toString());

      isLoading = true;
      _DashboardInit(temp, humidity, pressure);
    });
  }


  _DashboardInit(temp, humid, press) {
    progressController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000)); //5s

    tempAnimation =
        Tween<double>(begin: 0, end: temp).animate(progressController)
          ..addListener(() {
            setState(() {});
          });

    humidityAnimation =
        Tween<double>(begin: 0, end: humid).animate(progressController)
          ..addListener(() {
            setState(() {});
          });

    pressureAnimation =
    Tween<double>(begin: 1000, end: press).animate(progressController)
      ..addListener(() {
        setState(() {});
      });

    progressController.forward();
  }

  void _DashboadRenew() {
    databaseReference
        .child('temphum')
        .once().then((event) {
      dynamic dataSnapshot = event.snapshot;
      dynamic temp =
      double.parse((dataSnapshot.value['tem']['Data']).toString());
      dynamic humidity =
      double.parse((dataSnapshot.value['hum']['Data']).toString());
      dynamic pressure =
      double.parse((dataSnapshot.value['bar']['Data']).toString());

      tempAnimation =
      temp
        ..addListener(() {
          setState(() {});
        });
      isLoading = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kantur'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "iOT WeatherApp",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                    Icon(
                      Icons.sunny_snowing,
                      color: Colors.yellow,
                      size: 50.0,
                    ),
                    Text(
                      "made by Cem Deniz Önalp",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              trailing: Icon(Icons.play_arrow),
              title: Text('Buraya farklı lokasyon ekle'),
              leading: Icon(Icons.room),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: const Text('Çıkış...'),
              onTap: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
          child: isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CustomPaint(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text('Sıcaklık'),
                              Text(
                                '${tempAnimation.value.toInt()}',
                                style: const TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                '°C',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              RaisedButton.icon(onPressed:(){ _DashboadRenew();},
                                color: Colors.grey,
                                textColor: Colors.white,
                                label: Text("Yenile"),
                                icon: Icon(Icons.update),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    CustomPaint(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text('Nem'),
                              Text(
                                '${humidityAnimation.value.toInt()}',
                                style: const TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                '%',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              RaisedButton.icon(onPressed:(){ SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                                Navigator.pop(context);},
                                color: Colors.grey,
                                textColor: Colors.white,
                                label: Text("Yenile"),
                                icon: Icon(Icons.update),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    CustomPaint(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text('Basınç'),
                              Text(
                                '${pressureAnimation.value.toInt()}',
                                style: const TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                '%',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              RaisedButton.icon(onPressed:(){ SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                              Navigator.pop(context);},
                                color: Colors.grey,
                                textColor: Colors.white,
                                label: Text("Yenile"),
                                icon: Icon(Icons.update),)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : const Text(
                  'Giriş Yapılıyor...',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
    );
  }
}
