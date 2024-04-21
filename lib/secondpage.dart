import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SecondPage extends StatefulWidget {
  final String selectedEmoji;

  const SecondPage({Key? key, required this.selectedEmoji}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  // TextEditingController for text fields
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController employeeNameController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill the rating field with the selected emoji from the main page
    ratingController.text = getTextForRating(widget.selectedEmoji);
  }

  String getTextForRating(String emoji) {
    switch (emoji) {
      case '😊':
        return 'Excellent';
      case '😄':
        return 'Very Satisfied';
      case '🙂':
        return 'Satisfied';
      case '😐':
        return 'Not Satisfied';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Please fill up a short survey based on your rating.'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: ratingController,
              decoration: InputDecoration(
                labelText: 'Rating',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: employeeNameController,
              decoration: InputDecoration(
                labelText: 'Name of Employee',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: clientNameController,
              decoration: InputDecoration(
                labelText: 'Client Name',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: contactNumberController,
              decoration: InputDecoration(
                labelText: 'Contact Number',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: commentController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Comment/Suggestion',
              ),
            ),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  // Handle form submission here
                  submitForm();
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitForm() {
    // Access the entered values using the controllers
    String rating = ratingController.text;
    String employeeName = employeeNameController.text;
    String clientName = clientNameController.text;
    String contactNumber = contactNumberController.text;
    String address = addressController.text;
    String comment = commentController.text;

    // Get a Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Add a new document with a generated ID
    firestore.collection('survey').add({
      'rating': rating,
      'employeeName': employeeName,
      'clientName': clientName,
      'contactNumber': contactNumber,
      'address': address,
      'comment': comment,
    }).then((value) {
      // Show a SnackBar to indicate successful submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Client feedback submitted successfully!'),
          duration: Duration(seconds: 3), // Display SnackBar for 5 seconds
        ),
      );

      // Dispose the second page and navigate back to the main page after 5 seconds
      Future.delayed(Duration(seconds: 5), () {
        Navigator.pop(context); // Close the second page
      });
      
      // Optionally, you can navigate to another screen or show a success message here
    }).catchError((error) {
      // Handle errors
      print("Failed to submit form data: $error");
      // Optionally, you can show an error message here
    });
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    ratingController.dispose();
    employeeNameController.dispose();
    clientNameController.dispose();
    contactNumberController.dispose();
    addressController.dispose();
    commentController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Rating'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the second page and pass the selected rating
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SecondPage(selectedEmoji: '😊'), // Pass the selected rating here
              ),
            );
          },
          child: Text('Select Rating'),
        ),
      ),
    );
  }
}
