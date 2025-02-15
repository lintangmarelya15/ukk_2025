import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ukk_2025/homepage.dart';
import 'package:ukk_2025/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class insertproduk extends StatefulWidget {
  const insertproduk({super.key});

  @override
  State<insertproduk> createState() => _insertprodukState();

}

class _insertprodukState extends State<insertproduk> {
  final _nmprd = TextEditingController();
  final _harga = TextEditingController();
  final _stok = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  get doubel => null;

  Future<void> produk() async{
    if (_formKey.currentState!.validate()) {
      final NamaProduk = _nmprd.text;
      final Harga = double.tryParse(_harga.text) ?? 0;
      final Stok = int.tryParse(_stok.text) ?? 0;

      final response = await Supabase.instance.client.from('produk').insert(
        {
          'NamaProduk' : NamaProduk,
          'Harga' : Harga,
          'Stok' : Stok,
        }
      );
      if (response != null) {
        Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => HomePage())
        );
      } else {
        Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => HomePage())
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Poruk'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nmprd,
                decoration: InputDecoration(
                  labelText: 'Nama Produk', 
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _harga,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value){
                  if (value == null || value.isEmpty){
                    return 'Tidak boleh kosong';
                  } else {
                    if (double.tryParse(value) == null) {
                      return 'Harga harus angka';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _stok,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                  
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value){
                  if (value == null || value.isEmpty){
                    return 'Tidak boleh kosong';
                  } else {
                    if (double.tryParse(value) == null) {
                      return 'Stok harus angka';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: produk, 
                child: Text('Tambah'))
            ],
          ),
        ),
      ),
    );
  }
}
