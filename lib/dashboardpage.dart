import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

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
