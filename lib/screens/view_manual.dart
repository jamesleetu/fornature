import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewManual1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        title: Text('매뉴얼'),
        centerTitle: true,
      ),
      body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/manual1.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/manual2.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/manual3.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/manual4.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/manual5.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/manual6.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/manual7.jpg',
              ),
            ),
          ]),
    );
  }
}

class ViewManual2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        title: Text('매뉴얼'),
        centerTitle: true,
      ),
      body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/plastic_diet1.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/plastic_diet2.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/plastic_diet3.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/plastic_diet4.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/plastic_diet5.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/plastic_diet6.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/plastic_diet7.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/plastic_diet8.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/plastic_diet9.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/plastic_diet10.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/plastic_diet11.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                'assets/images/manual/plastic_diet12.jpg',
              ),
            ),
          ]),
    );
  }
}

class ViewManual3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        title: Text('매뉴얼'),
        centerTitle: true,
      ),
      body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          children: [
            Image.asset(
              'assets/images/manual/cup-attack.jpg',
            ),
          ]),
    );
  }
}

class ViewManual4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        title: Text('매뉴얼'),
        centerTitle: true,
      ),
      body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          children: [
            Image.asset(
              'assets/images/manual/hyundai_challenge.jpg',
            ),
          ]),
    );
  }
}
