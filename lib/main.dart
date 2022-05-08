// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Dashboard.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantur sıcaklık ve nem takibi',
      theme: ThemeData(
        primarySwatch: Colors.green, //renk
      ),
      home: giris(title: 'Kantur Sıcaklık ve Nem Takibi'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class giris extends StatefulWidget {
  final String title;
  giris({Key key, this.title}) : super(key: key);

  @override
  _girisState createState() => _girisState();
}

class _girisState extends State<giris> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email'],
  );

  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });

      if (_currentUser != null) {
        _handleFirebase();
      }
    });
    _googleSignIn.signInSilently();
  }

  void _handleFirebase() async {
    GoogleSignInAuthentication googleAuth = await _currentUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    final User firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      print('Giriş Başarılı');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Dashboard()));
    }
  }
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton.icon(
                onPressed: () {
                  _handleSignIn();
                },
                color: Colors.blue,
                textColor: Colors.white,
                label: const Text("Google Giris Yap"),
                icon: const Icon(Icons.update),
              ),
              RaisedButton.icon(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                color: Colors.blue,
                textColor: Colors.white,
                label: const Text("Google Çıkış Yap"),
                icon: const Icon(Icons.mode_standby),
              )
            ]),
      ),
    );
  }
}
