
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/penjualan/keranjang.dart';

class penjualan extends StatefulWidget {
  const penjualan({super.key});

  @override
  State<penjualan> createState() => _penjualanState();
}

class _penjualanState extends State<penjualan> {
  List<Map<String, dynamic>> penjualan = [];
  bool isLoading = true;

  fetchPenjualan() async {
    try {
      final response = await Supabase.instance.client
          .from('penjualan')
          .select('*, pelanggan(*)');
      setState(() {
        penjualan = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching penjualan: $e');
      setState(() {
        isLoading = false;
      });
    }
  }  

  Future<void> deletePenjualan(int id) async {
    try {
      await Supabase.instance.client
          .from('penjualan')
          .delete()
          .eq('PenjualanID', id);
      fetchPenjualan();
    } catch (e) {
      print('Error deleting penjualan: $e');
    }
  }
  
  @override
  initState() {
    super.initState();
    fetchPenjualan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
              itemCount: penjualan.length,
              itemBuilder: (context, index) {
                final item = penjualan[index];
                return ListTile(
                  title: Text(item['pelanggan']['NamaPelanggan']),
                  subtitle: Text('Total harga: ${item['TotalHarga']}'),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Hapus Pelanggan'),
                            content: const Text(
                                'Apakah anda yakin ingin menghapus produk ini?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  deletePenjualan(item['PenjualanID']);
                                  Navigator.pop(context);
                                  setState(() {
                                    penjualan.removeAt(index);
                                  });
                                },
                                child: const Text('Hapus'),
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var sales = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => produkdetail()),
          );

          if (sales == true) {
            fetchPenjualan();
          }
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add,),
      ),
    );
  }
}