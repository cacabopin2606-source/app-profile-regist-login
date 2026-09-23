import 'package:flutter/material.dart';

class MahasiswaPage extends StatelessWidget {
  const MahasiswaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget> [
          Text('Data Mahasiswa Kelompok 2', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('Berikut adalah data mahasiswa kelompok Badak Anggora.', style: TextStyle(fontSize: 16)),
          Text('Nadia', style: TextStyle(fontSize: 16)),
          Text('Fariq', style: TextStyle(fontSize: 16)),
          Text('Darma', style: TextStyle(fontSize: 16)),
          Text('Sony', style: TextStyle(fontSize: 16)),
          Text('Rapen', style: TextStyle(fontSize: 16)),
        ],
      )
    );
  }
}