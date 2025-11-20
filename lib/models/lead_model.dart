class Lead {
  final int? id;
  final String name;
  final String contact;
  final String notes;
  final String status;
  final int createdAt;

  Lead({
    this.id,
    required this.name,
    required this.contact,
    required this.notes,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'notes': notes,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory Lead.fromMap(Map<String, dynamic> map) {
    return Lead(
      id: map['id'] as int?,
      name: map['name'] as String,
      contact: map['contact'] as String,
      notes: map['notes'] as String,
      status: map['status'] as String,
      createdAt: map['createdAt'] as int,
    );
  }

  Lead copyWith({
    int? id,
    String? name,
    String? contact,
    String? notes,
    String? status,
    int? createdAt,
  }) {
    return Lead(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static const List<String> statusOptions = [
    'New',
    'Contacted',
    'Converted',
    'Lost',
  ];
}

