import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CreateComplaintScreen extends StatelessWidget {
  const CreateComplaintScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Pengaduan Baru'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: ComplaintForm(),
      ),
    );
  }
}

class ComplaintForm extends StatefulWidget {
  const ComplaintForm({Key? key}) : super(key: key);

  @override
  _ComplaintFormState createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final TextEditingController _complaintController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();

  Future<void> saveComplaintToDatabase(
      String complaintText, String photoURL) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? masyarakatId = prefs.getInt('masyarakat_id');

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/pengaduan/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'isi_laporan': complaintText,
        'foto': photoURL,
        'masyarakat_id': masyarakatId, // Pastikan nilai ini tidak null
      }),
    );

    if (response.statusCode == 200) {
      print('Data berhasil disimpan');
    } else {
      print('Gagal menyimpan data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _complaintController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Isi Laporan Pengaduan',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: _photoController,
            decoration: const InputDecoration(
              labelText: 'Foto (URL)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              String complaintText = _complaintController.text;
              String photoURL = _photoController.text;
              saveComplaintToDatabase(complaintText, photoURL);
            },
            child: const Text('Tambah Pengaduan'),
          ),
        ],
      ),
    );
  }
}
