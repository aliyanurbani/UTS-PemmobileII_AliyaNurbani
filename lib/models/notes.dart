class Note {
  String id;
  String judul;
  String isi;
  DateTime tanggal;

  Note({
    required this.id,
    required this.judul,
    required this.isi,
    required this.tanggal,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      judul: json['judul'],
      isi: json['isi'],
      tanggal: DateTime.parse(json['tanggal']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'tanggal': tanggal.toIso8601String(),
    };
  }
}
