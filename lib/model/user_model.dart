class UserModel {
  String nama;
  String alamat;
  String telp;
  String img;

  UserModel({
    required this.nama,
    required this.alamat,
    required this.telp,
    required this.img,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      nama: data['name'] ?? '',
      alamat: data['address'] ?? '',
      telp: data['telp'] ?? '',
      img: data['profile_pic'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'alamat': alamat,
      'telp': telp,
      'image': img,
    };
  }
}
