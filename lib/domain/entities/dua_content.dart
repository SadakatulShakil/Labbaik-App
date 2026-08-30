/// A single supplication tied to a chapter.
class DuaContent {
  const DuaContent({
    required this.id,
    required this.arabic,
    required this.translitBn,
    required this.meaningBn,
    required this.meaningEn,
    this.audioAsset,
  });

  factory DuaContent.fromJson(Map<String, dynamic> json) {
    return DuaContent(
      id: json['id'] as String,
      arabic: json['arabic'] as String,
      translitBn: json['translitBn'] as String,
      meaningBn: json['meaningBn'] as String,
      meaningEn: json['meaningEn'] as String,
      audioAsset: json['audioAsset'] as String?,
    );
  }

  final String id;
  final String arabic;
  final String translitBn;
  final String meaningBn;
  final String meaningEn;
  final String? audioAsset;
}
