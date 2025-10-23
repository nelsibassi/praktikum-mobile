import 'package:flutter/material.dart';

void main() {
  runApp(AplikasiBookingLapangan());
}

// Daftar global untuk menyimpan riwayat pemesanan
List<Map<String, dynamic>> riwayatBooking = [];

class AplikasiBookingLapangan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking Lapangan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      routes: {
        '/': (ctx) => HalamanMasuk(),
        '/daftar': (ctx) => HalamanDaftar(),
        '/beranda': (ctx) => HalamanUtama(),
        '/pesan': (ctx) => HalamanPemesanan(),
        '/profil': (ctx) => HalamanProfil(),
        '/riwayat': (ctx) => HalamanRiwayat(),
      },
      initialRoute: '/',
    );
  }
}

//////////////////////////////////////////////
/// HALAMAN MASUK (LOGIN)
//////////////////////////////////////////////
class HalamanMasuk extends StatefulWidget {
  @override
  _HalamanMasukState createState() => _HalamanMasukState();
}

class _HalamanMasukState extends State<HalamanMasuk> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  bool tampilPassword = true;
  bool ingatSaya = false;

  void masuk() {
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap isi email dan kata sandi!')),
      );
      return;
    }
    Navigator.pushReplacementNamed(context, '/beranda');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/field_bg.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.4))),
          Center(
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Masuk Aplikasi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      TextField(
                        controller: emailCtrl,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: passCtrl,
                        obscureText: tampilPassword,
                        decoration: InputDecoration(
                          labelText: 'Kata Sandi',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(tampilPassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => tampilPassword = !tampilPassword),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: ingatSaya,
                              onChanged: (v) =>
                                  setState(() => ingatSaya = v ?? false)),
                          Text('Ingat saya'),
                          Spacer(),
                          TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/daftar'),
                              child: Text('Daftar')),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: masuk,
                        icon: Icon(Icons.login),
                        label: Text('Masuk'),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 45)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////
/// HALAMAN DAFTAR AKUN
//////////////////////////////////////////////
class HalamanDaftar extends StatefulWidget {
  @override
  _HalamanDaftarState createState() => _HalamanDaftarState();
}

class _HalamanDaftarState extends State<HalamanDaftar> {
  final namaCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool setuju = false;
  String peran = "Pemain";

  void daftar() {
    if (!setuju) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Harap setujui syarat & ketentuan")));
      return;
    }
    Navigator.pushReplacementNamed(context, '/beranda');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Akun Baru')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: namaCtrl, decoration: InputDecoration(labelText: 'Nama Lengkap')),
            SizedBox(height: 10),
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 10),
            TextField(controller: passCtrl, obscureText: true, decoration: InputDecoration(labelText: 'Kata Sandi')),
            SizedBox(height: 15),
            Text('Peran', style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile(
              title: Text('Pemain'),
              value: 'Pemain',
              groupValue: peran,
              onChanged: (v) => setState(() => peran = v!),
            ),
            RadioListTile(
              title: Text('Penyewa Lapangan'),
              value: 'Penyewa',
              groupValue: peran,
              onChanged: (v) => setState(() => peran = v!),
            ),
            CheckboxListTile(
              value: setuju,
              title: Text('Saya menyetujui syarat & ketentuan'),
              onChanged: (v) => setState(() => setuju = v ?? false),
            ),
            ElevatedButton(onPressed: daftar, child: Text('Buat Akun')),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////
/// HALAMAN UTAMA (BERANDA)
//////////////////////////////////////////////
class HalamanUtama extends StatefulWidget {
  @override
  _HalamanUtamaState createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int index = 0;

  final List<Map<String, dynamic>> lapangan = List.generate(5, (i) => {
        'nama': 'Lapangan ${i + 1}',
        'harga': 50000 + (i * 10000),
        'foto': 'assets/field${(i % 3) + 1}.jpg',
      });

  @override
  Widget build(BuildContext context) {
    final pages = [
      _tampilanLapangan(context),
      HalamanRiwayat(),
      HalamanProfil(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Booking Lapangan')),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Nelsi'),
              accountEmail: Text('2309106120'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/profile.png'),
              ),
              decoration: BoxDecoration(color: Colors.green),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Riwayat Saya'),
              onTap: () => Navigator.pushNamed(context, '/riwayat'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Keluar'),
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
            ),
          ],
        ),
      ),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        selectedItemColor: Colors.green[900],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/pesan'),
        child: Icon(Icons.add),
        tooltip: 'Pesan Lapangan',
      ),
    );
  }

  Widget _tampilanLapangan(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: lapangan.length,
      itemBuilder: (ctx, i) {
        final f = lapangan[i];
        return Card(
          child: ListTile(
            leading: Image.asset(f['foto'], width: 70, fit: BoxFit.cover),
            title: Text(f['nama']),
            subtitle: Text('Rp ${f['harga']}/jam'),
            trailing: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/pesan', arguments: f),
              child: Text('Pesan'),
            ),
          ),
        );
      },
    );
  }
}

//////////////////////////////////////////////
/// HALAMAN PEMESANAN (Tambah input nama pemesan)
//////////////////////////////////////////////
class HalamanPemesanan extends StatefulWidget {
  @override
  _HalamanPemesananState createState() => _HalamanPemesananState();
}

class _HalamanPemesananState extends State<HalamanPemesanan> {
  Map<String, dynamic>? dataLapangan;
  DateTime? tanggal;
  TimeOfDay? waktu;
  String durasi = '1 jam';
  bool lampu = false;
  final TextEditingController namaPemesanCtrl = TextEditingController();

  @override
  void dispose() {
    namaPemesanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dataLapangan = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(title: Text('Pemesanan Lapangan')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: ListView(
          children: [
            if (dataLapangan != null)
              Image.asset(dataLapangan!['foto'], height: 150, fit: BoxFit.cover),
            SizedBox(height: 10),
            TextField(
              controller: namaPemesanCtrl,
              decoration: InputDecoration(
                labelText: 'Nama Pemesan',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: pilihTanggal,
              child: Text(tanggal == null
                  ? 'Pilih Tanggal'
                  : '${tanggal!.day}-${tanggal!.month}-${tanggal!.year}'),
            ),
            ElevatedButton(
              onPressed: pilihWaktu,
              child: Text(waktu == null
                  ? 'Pilih Waktu'
                  : '${waktu!.hour}:${waktu!.minute.toString().padLeft(2, '0')}'),
            ),
            RadioListTile(
              title: Text('1 jam'),
              value: '1 jam',
              groupValue: durasi,
              onChanged: (v) => setState(() => durasi = v!),
            ),
            RadioListTile(
              title: Text('2 jam'),
              value: '2 jam',
              groupValue: durasi,
              onChanged: (v) => setState(() => durasi = v!),
            ),
            SwitchListTile(
              title: Text('Gunakan lampu malam'),
              value: lampu,
              onChanged: (v) => setState(() => lampu = v),
            ),
            ElevatedButton(
              onPressed: konfirmasi,
              child: Text('Konfirmasi Pemesanan'),
            ),
          ],
        ),
      ),
    );
  }

  void pilihTanggal() async {
    final t = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (t != null) setState(() => tanggal = t);
  }

  void pilihWaktu() async {
    final w = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (w != null) setState(() => waktu = w);
  }

  void konfirmasi() {
    if (namaPemesanCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama pemesan belum diisi')),
      );
      return;
    }
    if (tanggal == null || waktu == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tanggal dan waktu belum dipilih')),
      );
      return;
    }

    riwayatBooking.add({
      'namaPemesan': namaPemesanCtrl.text,
      'lapangan': dataLapangan?['nama'] ?? 'Lapangan Tidak Diketahui',
      'tanggal': '${tanggal!.day}-${tanggal!.month}-${tanggal!.year}',
      'waktu': '${waktu!.hour}:${waktu!.minute.toString().padLeft(2, '0')}',
      'durasi': durasi,
      'lampu': lampu ? 'Ya' : 'Tidak',
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Berhasil!'),
        content: Text('Pemesanan atas nama ${namaPemesanCtrl.text} berhasil disimpan.'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('OK')),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////
/// HALAMAN RIWAYAT PEMESANAN
//////////////////////////////////////////////
class HalamanRiwayat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat Pemesanan')),
      body: riwayatBooking.isEmpty
          ? Center(child: Text('Belum ada riwayat pemesanan'))
          : ListView.builder(
              itemCount: riwayatBooking.length,
              itemBuilder: (ctx, i) {
                final r = riwayatBooking[i];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.sports_soccer),
                    title: Text('${r['lapangan']}'),
                    subtitle: Text(
                        'Nama: ${r['namaPemesan']}\nTanggal: ${r['tanggal']} | Waktu: ${r['waktu']}\nDurasi: ${r['durasi']} | Lampu: ${r['lampu']}'),
                  ),
                );
              },
            ),
    );
  }
}

//////////////////////////////////////////////
/// HALAMAN PROFIL
//////////////////////////////////////////////
class HalamanProfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil Saya')),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
                SizedBox(height: 10),
                Text('Nelsi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text('NIM: 2309106120', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('nelsi@student.unmul.ac.id'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Pengaturan Notifikasi'),
            trailing: Switch(value: true, onChanged: (_) {}),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Tentang Aplikasi'),
            subtitle: Text('Aplikasi Booking Lapangan — dibuat untuk tugas Pemrograman Mobile.'),
          ),
        ],
      ),
    );
  }
}