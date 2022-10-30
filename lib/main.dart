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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class Person {
  late String name, grade, email, phoneNumber, address, password;
  Person(this.name, this.grade, this.email, this.phoneNumber, this.address, this.password);
}

Person currentUser = Person('Bobby', '12', 'bobbyfred@gmail.com', '239-242-6477', '2489 Trestle Lane', 'bobthenoob');

Padding getForm(text, Function(String text) code){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 72, vertical: 16),
    child: TextField(onChanged: (text) { code(text); }, decoration: InputDecoration( border: const UnderlineInputBorder(), labelText: text))
  );
}

void push(context, widget){
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

Padding getBareButton(context, text, Function() code){
  return Padding(padding: const EdgeInsets.all(16), child: ElevatedButton(onPressed: code, child: Text(text)));
}

Padding getExtendedButton(context, text, Function() code, widget){
  return getBareButton(context, text, (){code(); push(context, widget);});
}

Padding getButton(context, text, widget){
  return getBareButton(context, text, () => push(context, widget));
}

Scaffold getScaffold(titleText, widgets){
  return getBareScaffold(titleText, Column( mainAxisAlignment: MainAxisAlignment.center, children: widgets));
}

Scaffold getBareScaffold(titleText, widget) {
  return Scaffold(appBar: AppBar(title: Center(child: Text(titleText)),), body: Center(child: widget));
}

Text getText(text){ return Text(text); }

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return getScaffold('Commroute', [
        getButton(context, 'Login To Existing Account', LoginScreen()),
        getButton(context, 'Create An Account', const CreateAccountScreen())
    ]);
  }
}

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    String name = "", grade = "", email = "", phone = "", address = "", password = "";
    return getScaffold('Create Your Account', [
      getForm('Full Name', (text) => name = text),
      getForm('Grade', (text) => grade = text),
      getForm('Email', (text) => email = text),
      getForm('Phone Number', (text) => phone = text),
      getForm('Home Address', (text) => address = text),
      getForm('Password', (text) => password = text),
      getExtendedButton(context, 'Done', () => {currentUser = Person(name, grade, email, phone, address, password)}, const HomeScreen())
    ]);
  }
}

class LoginScreen extends StatelessWidget{
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    String name = "", password = "";
    return getScaffold('Enter Your Name And Password', [
      getForm('First Name', (text) => name = text),
      getForm('Password', (text) => password = text),
      getBareButton(context, 'Log In', () => {
        if(name == currentUser.name && password == currentUser.password || true){
          push(context, const MatchesScreen())
        }
      })
    ]);
  }
}

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return getBareScaffold('Choose A Candidate', const Padding(padding: EdgeInsets.all(16), child: Matches()));
  }
}

class Matches extends StatefulWidget {
  const Matches({super.key});
  @override
  State<Matches> createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  final _suggestions = <Person>[
    Person('John Doe', '12', 'john.doe@gmail.com', '444-323-5594', '1234 Rocket Way', 'yessir24'),
    Person('Kyle Kleckner', '10', 'kyleisawesome@outlook.com', '131-213-3490', '1385 Dylatov Road', 'iml0st'),
    Person('Your Mom', '11', 'alex2005@gmail.com', '408-886-0345', '2094 Park Court', 'whynotthis')
  ];
  final _biggerFont = const TextStyle(fontSize: 18);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _suggestions.length*2,
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();
        final Person current = _suggestions[i ~/ 2];
        return ListTile(
          title: Text(
            current.name,
            style: _biggerFont,
          ),
          trailing: getButton(context, 'View', ProposeScreen(person: current))
        );
      },
    );
  }
}

class ProposeScreen extends StatelessWidget {
  final Person person;
  const ProposeScreen({super.key, required this.person});
  @override
  Widget build(BuildContext context) {
    return getScaffold('Accept Candidate?', [
      getText('Name: ${person.name}')
    ]);
  }
}
