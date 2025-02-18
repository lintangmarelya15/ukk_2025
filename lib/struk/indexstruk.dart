// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:ukk_2025/homepage.dart';

// class DetailPenjualan extends StatefulWidget {
//   const DetailPenjualan({super.key});

//   @override
//   State<DetailPenjualan> createState() => _DetailPenjualanState();
// }

// class _DetailPenjualanState extends State<DetailPenjualan> {
//   List<Map<String, dynamic>> detailll = [];
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchDetail();
//   }

//   Future<void> fetchDetail() async {
//     setState(() => isLoading = true);
//     try {
//       final response = await Supabase.instance.client
//         .from('detailpenjualan')
//         .select('*, penjualan(*, pelanggan(*)), produk(*)')
//         .order('TanggalPenjualan', ascending: false, referencedTable: 'penjualan');
//       setState(() => detailll = List<Map<String, dynamic>>.from(response));
//     } catch (e) {
//       print('Error: $e');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> transaksi(int produkID, int jumlahProduk, int subtotal) async {
//     try {
//       await Supabase.instance.client.from('penjualan').insert({
//         'produk_id': produkID,
//         'jumlah_produk': jumlahProduk,
//         'subtotal': subtotal,
//       });

//       final response = await Supabase.instance.client.from('produk').update({
//         'stok': Field('stok') - jumlahProduk, 
//       }).eq('id', produkID); 

//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Struk Pembelian'),
//             content: SingleChildScrollView(
//               child: ListBody(
//                 children: <Widget>[
//                   Text('Produk yang dibeli: ${detailll[0]['produk']['NamaProduk']}'),
//                   Text('Jumlah: $jumlahProduk'),
//                   Text('Subtotal: Rp. $subtotal'),
//                   Text('Total: Rp. ${subtotal * jumlahProduk}'),
//                   const SizedBox(height: 10),
//                   Text('Terima kasih telah berbelanja!'),
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('Tutup'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => HomePage()),
//                   );
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     } catch (e) {
//       print('Error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Terjadi kesalahan saat menyimpan pesanan')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Detail Penjualan'),
//         centerTitle: true,
//       ),
//       body: isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : detailll.isEmpty
//               ? const Center(
//                   child: Text('Tidak ada detail penjualan.'),
//                 )
//               : ListView.builder(
//                   padding: const EdgeInsets.all(12),
//                   itemCount: detailll.length,
//                   itemBuilder: (context, index) {
//                     final detail = detailll[index];
//                     final int Subtotal = int.tryParse(detail['Subtotal'].toString()) ?? 0;
//                     return Card(
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.all(16),
//                         title: Text(
//                           'Produk: ${detail['produk']['NamaProduk'] ?? '-'}',
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Nama Pelanggan: ${detail['penjualan']['pelanggan']['NamaPelanggan'] ?? '-'}'),
//                             Text('Jumlah: ${detail['JumlahProduk'] ?? '-'}'),
//                             Text('Subtotal: Rp. ${detail['Subtotal'] ?? '-'}'),
//                             Text('Tanggal Penjualan: ${detail['penjualan']['TanggalPenjualan'] ?? '-'}'),
//                           ],
//                         ),
//                         trailing: ElevatedButton(
//                           onPressed: () => transaksi(
//                             detail['produk']['id'], 
//                             detail['JumlahProduk'],  
//                             Subtotal,             
//                           ),
//                           child: const Text('Pesan'),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: fetchDetail,
//         child: const Icon(Icons.refresh),
//         backgroundColor: Colors.blue,
//       ),
//     );
//   }
// }
