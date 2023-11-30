import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateComplaintScreen extends StatefulWidget {
  @override
  _CreateComplaintScreenState createState() => _CreateComplaintScreenState();
}

class _CreateComplaintScreenState extends State<CreateComplaintScreen> {
  TextEditingController isiLaporanController = TextEditingController();
  TextEditingController fotoController = TextEditingController();
  GlobalKey<FormState> formKey =
      GlobalKey<FormState>(); // Form key for validation

  Future<void> submitData() async {
    if (formKey.currentState!.validate()) {
      var url = Uri.parse('http://127.0.0.1:8000/api/pengaduan/create');
      var response = await http.post(
        url,
        body: {
          'isi_laporan': isiLaporanController.text,
          'foto': fotoController.text,
          // 'kategori': kategoryController.text,
        },
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('message')) {
          // Data terkirim berhasil, tampilkan alert
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Sukses'),
                content: Text(responseData['message']),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(
                          context, '/home'); // Navigasi ke layar home
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          print('Respon tidak berisi pesan');
        }
      } else {
        print('Gagal mengirim data. Status: ${response.statusCode}');
        // Tampilkan pesan atau lakukan penanganan kesalahan lainnya
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat Pengaduan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: isiLaporanController,
                decoration: InputDecoration(labelText: 'Isi Laporan'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Isi Laporan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: fotoController,
                decoration: InputDecoration(labelText: 'Foto'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Foto tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  submitData();
                },
                child: Text('Kirim Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CreateComplaintScreen(),
  ));
}
