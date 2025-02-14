import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/homepage.dart';

class Editproduk extends StatefulWidget {
  final int ProdukID;
  const Editproduk({super.key, required this.ProdukID});

  @override
  State<Editproduk> createState() => _EditprodukState();
}

class _EditprodukState extends State<Editproduk> {
  final _nmprd = TextEditingController();
  final _harga = TextEditingController();
  final _stok = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadProdukData();
  }

  Future<void> _loadProdukData() async {
    try {
      final data = await Supabase.instance.client
          .from('produk')
          .select()
          .eq('ProdukID', widget.ProdukID)
          .single();

      setState(() {
        _nmprd.text = data['NamaProduk'] ?? '';
        _harga.text = data['Harga']?.toString() ?? '';
        _stok.text = data['Stok']?.toString() ?? '';
      });
    } catch (e) {
      print('Error loading produk data: $e');
    }
  }

  Future<void> _updateproduk() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Supabase.instance.client.from('produk').update({
          'NamaProduk': _nmprd.text,
          'Harga': double.tryParse(_harga.text) ?? 0,
          'Stok': int.tryParse(_stok.text) ?? 0,
        }).eq('ProdukID', widget.ProdukID);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false,
        );
      } catch (e) {
        print('Error updating produk: $e');
      }
    }
  }

  @override
  void dispose() {
    _nmprd.dispose();
    _harga.dispose();
    _stok.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nmprd,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _harga,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Harga harus angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stok,
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Stok harus angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateproduk,
                child: const Text('Update'),
              )
            ],
          ),
        ),
      ),
    );
  }
}