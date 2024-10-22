class UserModel {
  String nama;
  String telp;
  String img;

  UserModel({
    required this.nama,
    required this.telp,
    required this.img,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      nama: data['name'] ?? '',
      telp: data['telp'] ?? '',
      img: data['profile_pic'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'telp': telp,
      'image': img,
    };
  }
}
