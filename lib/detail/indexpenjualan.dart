import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/homepage.dart';

class detailpenjualan extends StatefulWidget {
  const detailpenjualan({super.key});

  @override
  State<detailpenjualan> createState() => _detailpenjualanState();
}

class _detailpenjualanState extends State<detailpenjualan> {
  List<Map<String, dynamic>> detailll = [];
  bool isLoading = false;

  // Persentase pajak (misalnya 10%)
  double taxPercentage = 0.10;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    setState(() => isLoading = true);
    try {
      final response = await Supabase.instance.client
          .from('detailpenjualan')
          .select('*, penjualan(*, pelanggan(*)), produk(*)')
          .order('TanggalPenjualan', ascending: false, referencedTable: 'penjualan');
      print(response);
      setState(() => detailll = List<Map<String, dynamic>>.from(response));
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Fungsi untuk menghitung pajak
  num getTaxAmount(int subtotal) {
    return subtotal * taxPercentage;
  }

  // Fungsi untuk menghitung total harga setelah pajak
  num getTotalWithTax(int subtotal) {
    return subtotal + getTaxAmount(subtotal);
  }

  Future<void> transaksi(int PelangganID, int Subtotal) async {
    try {
      await Supabase.instance.client.from('penjualan').insert({
        'PelangganID': PelangganID,
        'TotalHarga': Subtotal,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan berhasil disimpan!')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan saat menyimpan pesanan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.blue,
                  size: 40,
                ),
              )
            : detailll.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada detail penjualan.',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: detailll.length,
                    itemBuilder: (context, index) {
                      final detail = detailll[index];
                      final int Subtotal = int.tryParse(detail['Subtotal'].toString()) ?? 0;
                      final taxAmount = getTaxAmount(Subtotal);
                      final totalWithTax = getTotalWithTax(Subtotal);
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            'Produk: ${detail['produk']['NamaProduk'] ?? '-'}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nama Pelanggan: ${detail['penjualan']['pelanggan']['NamaPelanggan'] ?? '-'}'),
                              Text('Jumlah: ${detail['JumlahProduk'] ?? '-'}'),
                              Text('Subtotal: Rp. ${detail['Subtotal'] ?? '-'}'),
                              Text('Pajak (10%): Rp. ${taxAmount}'),
                              Text('Total + Pajak: Rp. ${totalWithTax}'),
                              Text('Tanggal Penjualan: ${detail['penjualan']['TanggalPenjualan'] ?? '-'}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchDetail,
        child: const Icon(Icons.refresh),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
