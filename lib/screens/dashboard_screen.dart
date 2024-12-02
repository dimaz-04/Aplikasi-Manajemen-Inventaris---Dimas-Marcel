import 'package:flutter/material.dart';


class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDashboardCard(
                  context,
                  icon: Icons.input,
                  title: "Barang Masuk",
                  onTap: () {
                    Navigator.pushNamed(context, '/barang-masuk');
                  },
                ),
                SizedBox(height: 20),

                // Barang Keluar (dengan icon berlawanan)
                _buildDashboardCard(
                  context,
                  icon: Icons.exit_to_app,
                  title: "Barang Keluar",
                  onTap: () {
                    Navigator.pushNamed(context, '/barang-keluar');
                  },
                ),
                SizedBox(height: 20),

                // Laporan
                _buildDashboardCard(
                  context,
                  icon: Icons.report,
                  title: "Laporan",
                  onTap: () {
                    Navigator.pushNamed(context, '/laporan');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom method to create dashboard cards
  Widget _buildDashboardCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap
      }) {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.blue),
        title: Text(
          title,
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w500
          ),
        ),
        onTap: onTap,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
      ),
    );
  }
}