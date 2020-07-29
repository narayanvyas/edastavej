class Service {
  final int id;
  final String title;
  final String imageUrl;
  final String description;
  final List transactions;
  String createdAt;
  String modifiedAt;
  final int createdBy;
  final int modifiedBy;
  final bool isActive;

  Service._(
      {this.id,
      this.title,
      this.imageUrl,
      this.description,
      this.transactions,
      this.createdAt,
      this.modifiedAt,
      this.createdBy,
      this.modifiedBy,
      this.isActive});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service._(
      id: json['ServiceId'],
      title: json['ServiceName'],
      imageUrl: json['ImageUrl'],
      description: json['ServiceDescription'],
      transactions: json['CustomerTransections'],
      createdAt: json['CreatedAt'],
      modifiedAt: json['ModifiedAt'],
      createdBy: json['CreatedBy'],
      modifiedBy: json['ModifiedBy'],
      isActive: json['IsActive'],
    );
  }
}
