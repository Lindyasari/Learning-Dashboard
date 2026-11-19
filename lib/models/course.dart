// Nama: Ni Komang Tri Lindyasari
// NIM: 2415051017

class Course {
  final int? id;
  final String? ownerId;
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({
    this.id,
    this.ownerId,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      ownerId: json['owner_id'] as String?,
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: (json['status'] as String?) ?? 'planned',
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'title': title,
    'credits': credits,
    'status': status,
  };
}