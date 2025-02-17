
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/homepage.dart';

class detailpenjualan extends StatefulWidget {
  const detailpenjualan({super.key});

  @override  
  State<detailpenjualan> createState() => _detailpenjualan();
}

class _detailpenjualan extends State<detailpenjualan> {
  List<Map<String, dynamic>> detailll = [];
  bool isLoading = true;

  @override  
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDeatil() async {
    setState(() {
      isLoading = true;
    });
    try{
      final response = await Supabase.instance.client
      .from('detailpenjualan')
      .select('*, penjualan(*, pelanggan(*)), produk')
      .order('TanggalPenjualan', ascending: false, referencedTable: 'penjualan');
    print(response);
    setState(() => detailll = List<Map<String, dynamic>>.from(response));
    
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> transaksi(int PelangganID, int Subtotal) async {
    try {
      await Supabase.instance.client
      .from('penjualan')
      .insert({
        'PelangganID' : PelangganID,
        'TotalHarga' : Subtotal,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan berhasil disimpan!')),
      );
      Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjai esalahan saat menyimpan pesanan')),
      );
    }
  }
}

@override  
Widget build(BuildContext context) {
  return Scaffold()
}