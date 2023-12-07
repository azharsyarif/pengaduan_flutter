import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreateComplaintScreen extends StatefulWidget {
  @override
  _CreateComplaintScreenState createState() => _CreateComplaintScreenState();
}

class _CreateComplaintScreenState extends State<CreateComplaintScreen> {
  TextEditingController isiLaporanController = TextEditingController();
  TextEditingController fotoController = TextEditingController();
  TextEditingController kategoriController = TextEditingController(); // Controller untuk kategori
  GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Form key for validation

  Future<void> submitData() async {
    if (formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');

      if (userId != null) {
        var url = Uri.parse('http://127.0.0.1:8000/api/pengaduan/create');
        var response = await http.post(
          url,
          body: {
            'isi_laporan': isiLaporanController.text,
            'foto': fotoController.text,
            'masyarakat_id': userId.toString(),
            'kategori': kategoriController.text, // Menggunakan data dari controller kategori
          },
        );

        if (response.statusCode == 201) {
          Map<String, dynamic> responseData = json.decode(response.body);
          if (responseData.containsKey('message')) {
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
                        Navigator.pushNamed(context, '/home');
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
        }
      } else {
        print('UserId tidak ditemukan dalam SharedPreferences');
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
              TextFormField(
                controller: kategoriController, // Controller untuk kategori
                decoration: InputDecoration(labelText: 'Kategori'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Kategori tidak boleh kosong';
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
