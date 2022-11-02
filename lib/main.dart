import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'locations.dart' as locations;

void main() {
  runApp(const MyApp());
}

class MyApp2 extends StatefulWidget {
  const MyApp2({super.key});

  @override
  State<MyApp2> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp2> {
  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Office Locations'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 2,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
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
  late String name, grade, email, phoneNumber, address, password, startTime;
  Person(this.name, this.grade, this.email, this.phoneNumber, this.address, this.startTime, this.password);
}

Person currentUser = Person('Bobby', '12', 'bobbyfred@gmail.com', '239-242-6477', '2489 Trestle Lane',  '8:00',  'bobthenoob');

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

Scaffold getScrollableScaffold(titleText, widgets){
  return getBareScaffold(titleText, ListView(children: widgets));
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
    return getScrollableScaffold('Create Your Account', [
      getForm('Full Name', (text) => name = text),
      getForm('Grade', (text) => grade = text),
      getForm('Email', (text) => email = text),
      getForm('Phone Number', (text) => phone = text),
      getForm('Home Address', (text) => address = text),
      getForm('Start Time', (text) => start = text),
      getFormPassword('Password', (text) => password = text),
      Column(children: [getExtendedButton(context, 'Done', () => {currentUser = Person(name, grade, email, phone, address, start, password)}, const HomeScreen())])
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
    Person('John Doe', '12', 'john.doe@gmail.com', '444-323-5594', '1234 Rocket Way',  '8:15',  'yessir24'),
    Person('Kyle Smith', '10', 'kyleisawesome@outlook.com', '131-213-3490', '1385 Dylatov Road',  '10:00',  'iml0st'),
    Person('Abishek Kumar', '11', 'thewiser2005@yahoo.com', '408-886-0345', '2094 Park Court',   '8:00',  'whynotthis')
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
  final bool mode = false;
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
