import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Future, async, await
  Future<String> fetchData() {
    return Future.delayed(Duration(seconds: 2), () => "Halo dari Future!");
  }

  // Files
  Future<String> loadAsset() async {
    return await rootBundle.loadString('database.json');
  }

  Future<void> writeToLocalFile(String data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/yay.txt');
    await file.writeAsString(data);
  }

  Future<String> readFromLocalFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/yay.txt');
      String fileContent = await file.readAsString();
      return fileContent;
    } catch (e) {
      print('Error reading local file: $e');
      return '';
    }
  }

  // JSON
  Map<String, dynamic> toJsonMap(String jsonString) {
    return json.decode(jsonString);
  }

  String toJsonString(Map<String, dynamic> data) {
    return json.encode(data);
  }

  // SharedPreferences
  Future<void> saveToSharedPreferences(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String> readFromSharedPreferences(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo Konsep Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Future, async, await
            ElevatedButton(
              onPressed: () {
                fetchData().then((data) {
                  print(data);
                });
              },
              child: Text('Ambil Data dari Future'),
            ),
            SizedBox(height: 20),
            // Files
            ElevatedButton(
              onPressed: () async {
                String fileContent = await loadAsset();
                print('Konten File: $fileContent');
              },
              child: Text('Baca Konten File'),
            ),
            ElevatedButton(
              onPressed: () async {
                await writeToLocalFile('Halo dari File Lokal!');
                print('Data berhasil ditulis ke file lokal');
              },
              child: Text('Tulis ke File Lokal'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String local = await readFromLocalFile();
                print('Konten File: $local');
              },
              child: Text('Baca dari File Lokal'),
            ),
            SizedBox(height: 20),
            // JSON
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> data = {'nama': 'Reviza', 'usia': 22};
                String jsonString = toJsonString(data);
                print('JSON String: $jsonString');
              },
              child: Text('Konversi ke JSON String'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String jsonString = '{"nama": "Arafil", "usia": 22}';
                Map<String, dynamic> data = toJsonMap(jsonString);
                print('JSON Map: $data');
              },
              child: Text('Konversi ke JSON Map'),
            ),
            SizedBox(height: 20),
            // SharedPreferences - Simpan Data
            ElevatedButton(
              onPressed: () async {
                try {
                  await saveToSharedPreferences('nama', 'Arafil');
                  await saveToSharedPreferences('NIM', '21343019');
                  print('Data berhasil disimpan ke SharedPreferences');
                } catch (e) {
                  print('Gagal menyimpan data ke SharedPreferences: $e');
                }
              },
              child: Text('Simpan Data ke SharedPreferences'),
            ),
            SizedBox(height: 20),
            // SharedPreferences - Baca Data
            ElevatedButton(
              onPressed: () async {
                try {
                  String name = await readFromSharedPreferences('nama');
                  String nim = await readFromSharedPreferences('NIM');
                  print('Data dari SharedPreferences: Nama: $name, NIM: $nim');
                } catch (e) {
                  print('Gagal membaca data dari SharedPreferences: $e');
                }
              },
              child: Text('Baca Data dari SharedPreferences'),
            ),
          ],
        ),
      ),
    );
  }
}
