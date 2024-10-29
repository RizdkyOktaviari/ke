import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _selectedGender = 'Pria';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.blue,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Buat Akun',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Daftar untuk memulai',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),
            _buildTextField('Nama'),
            SizedBox(height: 16),
            _buildTextField('Umur'),
            SizedBox(height: 16),
            _buildTextField('Pendidikan'),
            SizedBox(height: 16),
            _buildTextField('Pekerjaan'),
            SizedBox(height: 16),
            _buildTextField('Lama menderita Hipertensi'),
            SizedBox(height: 16),
            _buildTextField('No Handphone'),
            SizedBox(height: 24),
            Text(
              'Setting Notifikasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Aktivitas Fisik',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child:
                      Container(), // Placeholder untuk switch atau input lain
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Minum Obat',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Berapa kali sehari?',
                      hintStyle: TextStyle(color: Colors.blue[200]),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Jenis Kelamin',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Pria', style: TextStyle(color: Colors.blue)),
                    value: 'Pria',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Wanita', style: TextStyle(color: Colors.blue)),
                    value: 'Wanita',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Catatan tekanan darah pertama kali',
                hintStyle: TextStyle(color: Colors.blue[200]),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey!),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey!),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Implementasi Sign Up
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.blue[200]),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey!),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey!),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
