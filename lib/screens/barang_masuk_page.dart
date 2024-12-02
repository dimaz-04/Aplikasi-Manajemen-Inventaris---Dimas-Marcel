import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../services/database_helper.dart';

class BarangMasukPage extends StatefulWidget {
  @override
  _BarangMasukPageState createState() => _BarangMasukPageState();
}

class _BarangMasukPageState extends State<BarangMasukPage> {
  bool _isFormVisible = false;

  final List<String> availableBarang = [
    'Speaker Bluetooth',
    'Smart TV',
    'Kulkas',
    'Smartwatch',
  ];

  final List<String> availablePemasok = [
    'PT. Samsung Indonesia',
    'PT. LG Electronics',
    'PT. Huawei Indonesia',
    'PT. Sharp Electronics Indonesia',
    'PT. JBL Indonesia',
    'PT. Polytron',
  ];

  String? selectedBarang;
  TextEditingController noDokumenController = TextEditingController();
  TextEditingController pemasokController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  TextEditingController jumlahController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
  }

  void _resetForm() {
    selectedBarang = null;
    noDokumenController.clear();
    pemasokController.clear();
    keteranganController.clear();
    jumlahController.clear();
  }

  void _generateNomorDokumen() {
    if (selectedBarang == null) return;

    Map<String, String> kodeBarang = {
      'Speaker Bluetooth': '001',
      'Smart TV': '002',
      'Kulkas': '003',
      'Smartwatch': '004',
    };

    String kode = kodeBarang[selectedBarang] ?? '000';
    String tahun = DateFormat('yy').format(DateTime.now());
    String bulan = DateFormat('MM').format(DateTime.now());
    String hari = DateFormat('dd').format(DateTime.now());
    String urutan = DateTime.now().second.toString().padLeft(3, '0');
    noDokumenController.text = '$kode$tahun$bulan$hari$urutan';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Barang Masuk')),
      body: Stack(
        children: [
          _buildMainContent(),
          _buildFloatingAddButton(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: _isFormVisible
          ? _buildFormContent()
          : Text(
        'Tekan tombol + untuk menambahkan data',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildFormContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: selectedBarang,
            items: availableBarang
                .map((barang) =>
                DropdownMenuItem(value: barang, child: Text(barang)))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedBarang = value;
                _generateNomorDokumen();
              });
            },
            decoration: InputDecoration(labelText: 'Pilih Barang'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: pemasokController,
            decoration: InputDecoration(labelText: 'Pemasok'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: jumlahController,
            decoration: InputDecoration(labelText: 'Jumlah Barang'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _simpanBarangMasuk,
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingAddButton() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Row(
        mainAxisSize: MainAxisSize.min, // Agar Row hanya seluas isi
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _isFormVisible = true;
                _resetForm();
              });
            },
            child: Icon(Icons.add),
          ),
          SizedBox(width: 8), // Spasi antara tombol dan teks
          Text(
            "Tambah Barang",
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue, // Warna teks
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _simpanBarangMasuk() async {
    if (selectedBarang != null &&
        pemasokController.text.isNotEmpty &&
        jumlahController.text.isNotEmpty) {
      int jumlah = int.tryParse(jumlahController.text) ?? 0;

      BarangMasuk barangMasuk = BarangMasuk(
        noDokumen: noDokumenController.text,
        namaBarang: selectedBarang!,
        pemasok: pemasokController.text,
        jumlah: jumlah,
        keterangan: 'Default',
        tanggal: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );

      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.insertBarangMasuk(barangMasuk);

      setState(() {
        _isFormVisible = false;
      });
    }
  }
}
