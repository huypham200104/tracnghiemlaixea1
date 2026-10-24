/// Model đại diện cho một biển báo giao thông đường bộ
class TrafficSign {
  final String code;
  final String name;
  final String group;
  final String? image;
  final String description;
  final bool isInExam;
  final String? tips;

  const TrafficSign({
    required this.code,
    required this.name,
    required this.group,
    this.image,
    required this.description,
    this.isInExam = false,
    this.tips,
  });

  factory TrafficSign.fromJson(Map<String, dynamic> json) {
    return TrafficSign(
      code: json['code'] as String,
      name: json['name'] as String,
      group: json['group'] as String,
      image: json['image'] as String?,
      description: json['description'] as String? ?? '',
      isInExam: json['is_in_exam'] as bool? ?? false,
      tips: json['tips'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'group': group,
      'image': image,
      'description': description,
      'is_in_exam': isInExam,
      'tips': tips,
    };
  }

  TrafficSign copyWith({
    String? code,
    String? name,
    String? group,
    String? image,
    String? description,
    bool? isInExam,
    String? tips,
  }) {
    return TrafficSign(
      code: code ?? this.code,
      name: name ?? this.name,
      group: group ?? this.group,
      image: image ?? this.image,
      description: description ?? this.description,
      isInExam: isInExam ?? this.isInExam,
      tips: tips ?? this.tips,
    );
  }

  String get groupName {
    switch (group) {
      case 'cam':
        return 'Biển báo cấm';
      case 'hieulenh':
        return 'Biển hiệu lệnh';
      case 'nguyhiem':
        return 'Biển nguy hiểm';
      case 'chidan':
        return 'Biển chỉ dẫn';
      case 'phu':
        return 'Biển phụ';
      default:
        return 'Khác';
    }
  }
}
