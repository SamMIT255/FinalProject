import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:navigation1/auth/authenticationService.dart';
import 'package:navigation1/secondpage.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';


//import 'dart:js';
//import 'dart:js_interop';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

if (kIsWeb){
await Firebase.initializeApp(options: const FirebaseOptions(
  apiKey: "AIzaSyDs-52NT3BTNpyJeUojqsT-XmHu30MWVm0",
  authDomain: "finalproject-3295d.firebaseapp.com",
  projectId: "finalproject-3295d",
  storageBucket: "finalproject-3295d.appspot.com",
  messagingSenderId: "1072048267684",
  appId: "1:1072048267684:web:596c6e56244f986fc9a131",
  measurementId: "G-6EQ33GF4PB"));
  
}else{
await Firebase.initializeApp();
}

  runApp(const MyApp());
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIT255 FINAL PROJECT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Client Satisfactory Survey'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedEmoji = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            emojiButton('😊', 'Excellent'), // Emoji for excellent
            emojiButton('😄', 'Very satisfied'), // Emoji for very satisfied
            emojiButton('🙂', 'Satisfied'), // Emoji for satisfied
            emojiButton('😐', 'Not satisfied'), // Emoji for not satisfied
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show login page popup when FAB is clicked
          _showLoginPopup(context);
        },
        child: Icon(Icons.login),
      ),
    );
  }

  // Function to create emoji buttons with corresponding text
  Widget emojiButton(String emoji, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEmoji = emoji; // Set the selected emoji
        });
        // Navigate to the second page after selecting an emoji
        Navigator.push(
          context as BuildContext,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                SecondPage(selectedEmoji: selectedEmoji),
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            selectedEmoji = emoji; // Set the selected emoji when hovered
          });
        },
        onExit: (_) {
          setState(() {
            selectedEmoji = ''; // Clear the selected emoji when not hovered
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.all(selectedEmoji == emoji
              ? 20
              : 10), // Increase padding when hovered
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selectedEmoji == emoji
                ? Colors.blue
                : Colors.transparent, // Change color when selected
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: TextStyle(
                    fontSize: selectedEmoji == emoji
                        ? 60.0
                        : 40.0), // Increase font size when hovered
              ),
              SizedBox(height: 10), // Add space between emoji and text
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: selectedEmoji == emoji
                      ? Colors.blue
                      : Colors.black, // Change color when selected
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show login page popup
  void _showLoginPopup(BuildContext context) {
    String email = '';
    String password = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/logo.png'), // Placeholder for logo image
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Sign in with email and password
                  UserCredential userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  // Once login is successful, navigate to Dashboard page
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => DashboardPage(),
                    ),
                  );
                } catch (error) {
                  // Handle login error
                  print(error);
                  // Show error message to the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Failed to login. Please check your email and password.'),
                    ),
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }
}

// Define the DashboardPage class outside of the _MyHomePageState class

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  List<Map<String, dynamic>>? get surveyData => null;

  Future<void> _logout(BuildContext context) async {
    Navigator.pop(context); // Navigates back to the previous page (assuming it's the login page)
  }

  Future<void> _downloadExcel(BuildContext context, List<Map<String, dynamic>> surveyData) async {
    // Create an Excel workbook
    final Excel excel = Excel.createExcel();
    final Sheet sheetObject = excel['Sheet1'];

    // Add headers
    sheetObject.appendRow([
  CellValueString('Survey ID'),
  CellValueString('Rating'),
  CellValueString('Employee'),
  CellValueString('Client Name'),
  CellValueString('Contact Number'),
  CellValueString('Address'),
  CellValueString('Comment'),
]);


    // Add data
    for (final data in surveyData) {
      sheetObject.appendRow([
        data['id'],
        data['rating'],
        data['employeeName'],
        data['clientName'],
        data['contactNumber'],
        data['address'],
        data['comment'],
      ]);
    }

    // Save the Excel file
    final List<int>? excelBytes = excel.encode();

    // Save the Excel file locally
    final directory = (await getExternalStorageDirectory())!.path;
    final fileName = 'survey_data.xlsx';
    final filePath = '$directory/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(excelBytes!);

    // Open the Excel file with the appropriate application
    OpenFile.open(filePath);

    debugPrint('Excel file saved as $filePath');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              // Call the logout function when the logout button is pressed
              _logout(context);
            },
            icon: Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {
              // Call the _downloadExcel function when the download button is pressed
              _downloadExcel(context, surveyData!); // Pass the survey data to the function
            },
            icon: Icon(Icons.file_download),
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('survey').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Map<String, dynamic>> surveyData = [];
              for (final doc in snapshot.data!.docs) {
                surveyData.add({
                  'id': doc.id,
                  'rating': doc['rating'],
                  'employeeName': doc['employeeName'],
                  'clientName': doc['clientName'],
                  'contactNumber': doc['contactNumber'],
                  'address': doc['address'],
                  'comment': doc['comment'],
                });
              }
              return ListView.builder(
                itemCount: surveyData.length,
                itemBuilder: (context, index) {
                  final data = surveyData[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Background color
                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), // Shadow position
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Survey ID: ${data['id']}', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.0),
                        Text('Rating: ${data['rating']}'),
                        Text('Employee: ${data['employeeName']}'),
                        Text('Client Name: ${data['clientName']}'), // Added client name field
                        Text('Contact Number: ${data['contactNumber']}'),
                        Text('Address: ${data['address']}'),
                        Text('Comment: ${data['comment']}'),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
  CellValueString(String s) {}
  
  getExternalStorageDirectory() {}
}


