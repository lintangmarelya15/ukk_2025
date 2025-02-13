
import 'package:flutter/material.dart';
import 'package:ukk_2025/main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; 

  
  final List<Widget> _pages = [
  //di isi bagian widget class
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green[400],
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.dashboard),
            //   title: Text('Registrasi'),
            //   onTap: () {
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => UserReg()));
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.arrow_back),
            //   title: Text('Logout'),
            //   onTap: () {
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            //   },
            // )
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages, 
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[400],
        unselectedItemColor: Colors.grey,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Pelanggan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Penjualan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.drafts),
            label: 'Detail Penjualan',
          ),
        ],
      ),
    );
  } 
}

// // Pages for each tab
// class CustomerPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         'Halaman Customer',
//         style: TextStyle(fontSize: 18),
//       ),
//     );
//   }
// }

// class ProdukPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         'Halaman Produk',
//         style: TextStyle(fontSize: 18),
//       ),
//     );
//   }
// }

// class PenjualanPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         'Halaman Penjualan',
//         style: TextStyle(fontSize: 18),
//       ),
//     );
//   }
// }