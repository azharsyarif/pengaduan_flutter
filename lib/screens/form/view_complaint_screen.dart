import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ComplaintsPage extends StatefulWidget {
  @override
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  List<dynamic> complaints = [];
  int userIdFromSharedPreferences = 1; // Ganti dengan logika untuk mendapatkan userId dari SharedPreferences

  Future<List<dynamic>> fetchComplaints(int userId) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/get-pengaduan/$userId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> complaintList = responseData['pengaduan'];
      return complaintList;
    } else {
      throw Exception('Failed to load complaints');
    }
  }

  @override
  void initState() {
    super.initState();
    // Mengambil data pengaduan saat halaman dimuat
    fetchComplaints(userIdFromSharedPreferences).then((complaintData) {
      setState(() {
        complaints = complaintData;
      });
    }).catchError((error) {
      print('Error: $error');
      // Handle error jika diperlukan
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pengaduan'),
      ),
      body: ListView.builder(
        itemCount: complaints.length,
        itemBuilder: (BuildContext context, int index) {
          Color statusColor;
          switch (complaints[index]['status']) {
            case 'proses':
              statusColor = Colors.yellow; // Ubah warna sesuai dengan status
              break;
            case 'selesai':
              statusColor = Colors.green; // Ubah warna sesuai dengan status
              break;
            case 'ditolak':
              statusColor = Colors.red; // Ubah warna sesuai dengan status
              break;
            default:
              statusColor = const Color.fromARGB(255, 245, 166, 166); // Warna default jika tidak cocok dengan status yang diberikan
              break;
          }

          return ListTile(
            title: Text('ID: ${complaints[index]['id']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tanggal Pengaduan: ${complaints[index]['tgl_pengaduan']}'),
                Text('Isi Laporan: ${complaints[index]['isi_laporan']}'),
                Text('Kategori: ${complaints[index]['kategori']}'),
                Text('Status: ${complaints[index]['status']}'),
                // Tambahkan atribut lain yang diperlukan
              ],
            ),
            onTap: () {
              // Tampilkan detail pengaduan jika diperlukan
            },
            // Container untuk mengatur warna berdasarkan status
            tileColor: statusColor,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); // Kembali ke halaman sebelumnya
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ComplaintsPage(),
  ));
}
