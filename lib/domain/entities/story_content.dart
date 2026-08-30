/// Optional narrative attached to a chapter (e.g. a companion's account).
class StoryContent {
  const StoryContent({
    required this.titleBn,
    required this.titleEn,
    required this.bodyBn,
    required this.bodyEn,
    this.imageAsset,
    this.audioAsset,
  });

  factory StoryContent.fromJson(Map<String, dynamic> json) {
    return StoryContent(
      titleBn: json['titleBn'] as String,
      titleEn: json['titleEn'] as String,
      bodyBn: json['bodyBn'] as String,
      bodyEn: json['bodyEn'] as String,
      imageAsset: json['imageAsset'] as String?,
      audioAsset: json['audioAsset'] as String?,
    );
  }

  final String titleBn;
  final String titleEn;
  final String bodyBn;
  final String bodyEn;
  final String? imageAsset;
  final String? audioAsset;
}
