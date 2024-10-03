class Pengguna {
  String email;
  String pass;
  String nama;
  String alamat;
  String telp;
  String img;

  Pengguna({
    required this.email,
    required this.pass,
    required this.nama,
    required this.alamat,
    required this.telp,
    required this.img,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'pass': pass,
      'nama': nama,
      'alamat': alamat,
      'telp': telp,
      'image': img,
    };
  }
}
