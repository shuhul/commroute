import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Commroute',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class Person {
  late String name, grade, email, phoneNumber, address, password, startTime, schoolAddress;
  Person(this.name, this.grade, this.email, this.phoneNumber, this.address, this.schoolAddress, this.startTime, this.password);
}

Person currentUser = Person('Bobby', '12', 'bobbyfred@gmail.com', '239-242-6477', '2489 Trestle Lane', '2398 Bohgr Fiji',  '8:00',  'bobthenoob');

Padding getForm(text, Function(String text) code){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 72, vertical: 16),
    child: TextField(onChanged: (text) { code(text); }, decoration: InputDecoration( border: const UnderlineInputBorder(), labelText: text))
  );
}

Padding getFormPassword(text, Function(String text) code){
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 72, vertical: 16),
      child: TextField(onChanged: (text) { code(text); }, obscureText: true, decoration: InputDecoration( border: const UnderlineInputBorder(), labelText: text))
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

Padding getText(text, size){ return Padding(padding: const EdgeInsets.all(16), child: Text(text, style: TextStyle(fontSize: size))); }

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
    String name = "", grade = "", email = "", phone = "", address = "", school = "",  start = "",  password = "";
    return getScaffold('Create Your Account', [
      getForm('Full Name', (text) => name = text),
      getForm('Grade', (text) => grade = text),
      getForm('Email', (text) => email = text),
      getForm('Phone Number', (text) => phone = text),
      getForm('Home Address', (text) => address = text),
      getForm('School Address', (text) => school = text),
      getForm('Start Time', (text) => start = text),
      getFormPassword('Password', (text) => password = text),
      getExtendedButton(context, 'Done', () => {currentUser = Person(name, grade, email, phone, address, school, start, password)}, const HomeScreen())
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
      getFormPassword('Password', (text) => password = text),
      getBareButton(context, 'Log In', () => {
        // REMOVE TRUE
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
    // Person('Shuhul Mujoo', '12', 'example@gmail.com', '123-456-7891', '3892 Red Way', '8930 Water Park',  '8:15',  'bobthenoob'),
    Person('John Doe', '12', 'john.doe@gmail.com', '444-323-5594', '1234 Rocket Way', '2398 Bohr Road',  '8:15',  'yessir24'),
    Person('Kyle Smith', '10', 'kyleisawesome@outlook.com', '131-213-3490', '1385 Dylatov Road', '2398 Bohr Road',  '10:00',  'iml0st'),
    Person('Abishek Kumar', '11', 'thewiser2005@yahoo.com', '408-886-0345', '2094 Park Court', '2398 Bohr Road',  '8:00',  'whynotthis')
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _suggestions.length*2,
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();
        final Person current = _suggestions[i ~/ 2];
        return ListTile(title: getText(current.name, 18), trailing: getButton(context, 'View', ProposeScreen(person: current)));
      },
    );
  }
}

class ProposeScreen extends StatelessWidget {
  final Person person;
  const ProposeScreen({super.key, required this.person});
  final bool mode = true;
  @override
  Widget build(BuildContext context) {
    return getScaffold(mode ? 'Accept Invitation?': 'Request Candidate?', [
      getText('Name: ${person.name}', 16),
      getText('Grade: ${person.grade}', 16),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        getButton(context, mode ? 'Accept': 'Send Request', ConfirmedScreen(person: person)),
        getButton(context, mode ? 'Decline': 'Back', const MatchesScreen())
      ])
    ]);
  }
}


class ConfirmedScreen extends StatelessWidget {
  final Person person;
  const ConfirmedScreen({super.key, required this.person});
  @override
  Widget build(BuildContext context) {
    return getScaffold('Confirmed', [
      getText('Name: ${person.name}', 16),
      getText('Grade: ${person.grade}', 16),
      getText('Email: ${person.email}', 16),
      getText('Phone: ${person.phoneNumber}', 16),
      getText('Home Address: ${person.address}', 16),
      getText('Start Time: ${person.startTime}', 16),
      getButton(context, 'Cancel', const MatchesScreen())
    ]);
  }
}
