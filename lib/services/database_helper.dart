import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class BarangMasuk {
  final int? id;
  final String noDokumen;
  final String namaBarang;
  final String pemasok;
  final String keterangan;
  final int jumlah;
  final String tanggal;

  BarangMasuk({
    this.id,
    required this.noDokumen,
    required this.namaBarang,
    required this.pemasok,
    required this.keterangan,
    required this.jumlah,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'noDokumen': noDokumen,
      'namaBarang': namaBarang,
      'pemasok': pemasok,
      'keterangan': keterangan,
      'jumlah': jumlah,
      'tanggal': tanggal,
    };
  }

  static BarangMasuk fromMap(Map<String, dynamic> map) {
    return BarangMasuk(
      id: map['id'],
      noDokumen: map['noDokumen'],
      namaBarang: map['namaBarang'],
      pemasok: map['pemasok'],
      keterangan: map['keterangan'],
      jumlah: map['jumlah'],
      tanggal: map['tanggal'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database ?? (throw Exception('Failed to initialize database'));
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'barang_masuk.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE barang_masuk(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            noDokumen TEXT,
            namaBarang TEXT,
            pemasok TEXT,
            keterangan TEXT,
            jumlah INTEGER,
            tanggal TEXT
          )
          ''',
        );
      },
    );
  }

  Future<void> insertBarangMasuk(BarangMasuk barangMasuk) async {
    try {
      final db = await database;
      await db.insert(
        'barang_masuk',
        barangMasuk.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting data: $e');
      throw Exception('Failed to insert data');
    }
  }

  Future<List<BarangMasuk>> getBarangMasuk() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('barang_masuk');

    return List.generate(maps.length, (i) {
      return BarangMasuk.fromMap(maps[i]);
    });
  }

  Future<void> deleteBarangMasuk(String noDokumen) async {
    try {
      final db = await database;
      await db.delete(
        'barang_masuk',
        where: 'noDokumen = ?',
        whereArgs: [noDokumen],
      );
    } catch (e) {
      print('Error deleting data: $e');
      throw Exception('Failed to delete data');
    }
  }
}
