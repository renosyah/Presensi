class Kelas {
  String makul;
  int pertemuan;
  String qrCode;
  List<Mahasiswa> mahasiswa;

  Kelas({this.makul, this.pertemuan, this.qrCode, this.mahasiswa});

  Kelas.fromJson(Map<String, dynamic> json) {
    makul = json['makul'];
    pertemuan = json['pertemuan'];
    qrCode = json['qr_code'];
    if (json['mahasiswa'] != null) {
      mahasiswa = new List<Mahasiswa>();
      json['mahasiswa'].forEach((v) {
        mahasiswa.add(new Mahasiswa.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['makul'] = this.makul;
    data['pertemuan'] = this.pertemuan;
    data['qr_code'] = this.qrCode;
    if (this.mahasiswa != null) {
      data['mahasiswa'] = this.mahasiswa.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Mahasiswa {
  String nim;
  String nama;
  bool hadir;
  String waktu;

  Mahasiswa({this.nim, this.nama, this.hadir, this.waktu});

  Mahasiswa.fromJson(Map<String, dynamic> json) {
    nim = json['nim'];
    nama = json['nama'];
    hadir = json['hadir'];
    waktu = json['waktu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nim'] = this.nim;
    data['nama'] = this.nama;
    data['hadir'] = this.hadir;
    data['waktu'] = this.waktu;
    return data;
  }
}