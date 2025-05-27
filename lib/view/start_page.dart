import 'package:flutter/material.dart';
import 'package:flutter_to_do/utils/constants.dart';
import 'package:flutter_to_do/view/home.dart';
import 'package:flutter_to_do/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _buildBody(screenSize, context),
      ),
    );
  }

  Widget _buildBody(Size screenSize, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      child: Column(
        children: [
          _buildImageSection(screenSize),
          _buildTextSection(screenSize, context),
          _buildGetStartedButton(screenSize, context),
        ],
      ),
    );
  }

  Widget _buildImageSection(Size screenSize) {
    return Expanded(
      flex: 3,
      child: Center(
        child: Image.asset(
          'assets/images/todo.png',
          height: screenSize.height * 0.5,
          width: screenSize.width * 0.8,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildTextSection(Size screenSize, BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          _buildHeadingText(screenSize, context),
          SizedBox(height: screenSize.height * 0.01),
          _buildSubheadingText(screenSize, context),
        ],
      ),
    );
  }

  Widget _buildHeadingText(Size screenSize, BuildContext context) {
    return FittedBox(
      child: Text(
        'Track. Complete. Repeat.\n Stay productive.',
        style: Theme.of(context).textTheme.displaySmall!.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 24, 51, 52),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubheadingText(Size screenSize, BuildContext context) {
    return FittedBox(
      child: Text(
        'Organize your tasks with ease daily',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildGetStartedButton(Size screenSize, BuildContext context) {
    return Expanded(
      flex: 1,
      child: Center(
        child: SizedBox(
          width: screenSize.width * 0.8,
          child: ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('start_seen', true); // ✅ Save seen status
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            style: _buttonStyle(screenSize),
            child: _buttonText(screenSize, context),
          ),
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle(Size screenSize) {
    return ElevatedButton.styleFrom(
      backgroundColor: Constants.appbarColor,
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.015),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  Widget _buttonText(Size screenSize, BuildContext context) {
    return Text(
      'GET STARTED',
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
        fontSize: screenSize.width * 0.04,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
    );
  }
}
