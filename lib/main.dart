import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Commroute',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}


Padding getForm(text){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 72, vertical: 16),
    child: TextFormField( decoration: InputDecoration( border: const UnderlineInputBorder(), labelText: text,)),
  );
}

Padding getButton(context, text, widget){
  return Padding(padding: const EdgeInsets.all(16), child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => widget),
      );
    },
    child: Text(text),
  ));
}

Scaffold getScaffold(titleText, widgets){
  return Scaffold(
    appBar: AppBar(title: Center(child: Text(titleText)),),
    body: Center( child: Column( mainAxisAlignment: MainAxisAlignment.center, children: widgets)),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return getScaffold('Commroute', [
        getButton(context, 'Login To Existing Account', const LoginScreen()),
        getButton(context, 'Create An Account', const CreateAccountScreen())
    ]);
  }
}

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return getScaffold('Create Your Account', [
      getForm('Full Name'),
      getForm('Grade'),
      getForm('Email'),
      getForm('Phone Number'),
      getForm('Home Address'),
      getForm('Password'),
      getButton(context, 'Done', const HomeScreen())
    ]);
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return getScaffold('Enter Your Name And Password', [
      getForm('First Name'),
      getForm('Password'),
      getButton(context, 'Log In', const HomeScreen())
    ]);
  }
}
