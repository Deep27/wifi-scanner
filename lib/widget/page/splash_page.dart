import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return isLandscape ? Logo(0.8, 0.15) : Logo(0.8, 0.1);
  }
}

class Logo extends StatelessWidget {
  final double maxWidth;
  final double maxHeight;

  Logo(this.maxWidth, this.maxHeight);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraits) {
        final path = "assets/images/logo_medium_resolution.png";
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: constraits.maxWidth * maxWidth,
                    height: constraits.maxHeight * maxHeight,
                    child: Image.asset(
                        path,
                        fit: BoxFit.fitHeight),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
