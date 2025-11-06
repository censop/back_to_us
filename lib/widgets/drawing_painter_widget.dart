
import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final List<List<Offset>> paths;
  final List<Color> colors;
  final List<double> strokeWidths; 

  DrawingPainter({
    required this.paths,
    required this.colors,
    this.strokeWidths = const [],
  });
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < paths.length; i++) {
      if (paths[i].isEmpty) continue; 
      
      final paint = Paint()
        ..color = colors[i]
        ..strokeWidth = strokeWidths.isEmpty ? 4.0 : strokeWidths[i]
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(paths[i][0].dx, paths[i][0].dy);
      
      for (int j = 1; j < paths[i].length; j++) {
        path.lineTo(paths[i][j].dx, paths[i][j].dy);
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}