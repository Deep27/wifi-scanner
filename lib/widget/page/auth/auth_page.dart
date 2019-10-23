import 'package:flutter/material.dart';
import 'package:wifi_scanner/route/router.dart';
import 'package:wifi_scanner/widget/page/spots/spots_page.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  final _focus = FocusNode();

  String _login = '';
  String _password = '';

  @override
  Widget build(BuildContext context) { 

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: TextField(
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => FocusScope.of(context).requestFocus(_focus),
                onChanged: (input) => _login = input,
                decoration: InputDecoration(
                  hintText: 'Login',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              child: TextField(
                focusNode: _focus,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onChanged: (input) => _password = input,
                onEditingComplete: _auth,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: FlatButton(
                  child: Text('Login'),
                  onPressed: _auth,
                  color: Theme.of(context).buttonColor, 
                )),
          ],
        ),
      ),
    );
  }

  _auth() {
    Navigator.of(context).pushReplacement(Router.createRoute(SpotsPage()));
    // _LOG.i("Handling button onclick.");
    // final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    // weatherBloc.add(GetWeather(cityName));
  }
}
