class PCBDefect {
  final double x, y, w, h;

  PCBDefect({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  factory PCBDefect.fromJson(Map<String, dynamic> json) {
    return PCBDefect(
      x: (json['x'] ?? 0).toDouble(),
      y: (json['y'] ?? 0).toDouble(),
      w: (json['w'] ?? 0).toDouble(),
      h: (json['h'] ?? 0).toDouble(),
    );
  }
}

class InspectionResult {
  final List<PCBDefect> defects;

  InspectionResult({required this.defects});

  factory InspectionResult.fromJson(Map<String, dynamic> json) {
    final list = json['defects'] as List? ?? [];
    return InspectionResult(
      defects: list.map((e) => PCBDefect.fromJson(e)).toList(),
    );
  }
}
