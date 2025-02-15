
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/pelanggan/insertpelanggan.dart';
import 'package:ukk_2025/pelanggan/updatepelanggan.dart';

class pelanggan extends StatefulWidget {
  @override
  _pelangganState createState() => _pelangganState();
}

class _pelangganState extends State<pelanggan> {
  List<Map<String, dynamic>> pelaggan =[];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchpelanggan();
  }

  Future<void> fetchpelanggan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = 
      await Supabase.instance.client 
        .from('pelanggan')
        .select();
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetchinig pelanggan: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deletepelanggan(int id) async {
    try {
      await Supabase.instance.client
        .from('pelangan')
        .delete()
        .eq('PelangganID', id);
      fetchpelanggan();
    } catch (e) {
      print('Eror deleting pelanggan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
      ? Center(
        child: LoadingAnimationWidget.twoRotatingArc(
          color: Colors.grey, size: 30),
      )
      : pelanggan.isEmpty
      ? Center(
        child: Text(
          'Tidak ada pelangan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      )
      :GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          ), 
          padding: EdgeInsets.all(8),
          itemCount: pelanggan.length,
          itemBuilder: (context, index) {
            final langgan = pelangan[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      langgan['NamaPelanggan'] ??
                      'Pelanggan Tidak Tersedia',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      langgan['Alamat'] ?? 'Alamat Tidak Tersedia',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      langgan['NomorTelepon'] ?? 'Nomor Telepon Tidak Tersediia',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.justify,
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                           icon: const Icon(Icons.edit,
                           color: Colors.blue),
                           onPressed: () {
                            final PelangganID = langgan[
                              'PelangganID'] ?? 0;
                            if (PelangganID != 0) {
                              Navigator.push(context, 
                              MaterialPageRoute(
                                builder: (context) => 
                                EditPelanggan(PelangganID: PelangganID))
                                );
                            } else {
                              print('ID Pelanggan Tidak Valid');
                            }
                           },
                           ),
                           IconButton(
                            icon: const Icon(Icons.delete,
                            color: Colors.grey),
                            onPressed: () {
                              showDialog(
                                context: context, 
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Hapus Pelanggan'),
                                    content: const Text(
                                      'Apakah Anda yakin ingin menghapus pelanggan ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                          Navigator.pop(context),
                                          child: const Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deletepelanggan(
                                                langgan['PelangganID']);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Hapus'),
                                          )
                                      ],
                                  );
                                }
                                );
                            },
                            )
                      ],
                    )

                  ],
                ),
                ),
            );
          },
        ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddPelanggan()),
        );
      },
      child: Icon(Icons.add),
      ),
    );
  }
}