import 'package:flutter/material.dart';

/// A container with a blueprint-style width indicator above it.
/// Shows a horizontal line with the width measurement centered on it,
/// similar to architectural blueprints.
class BlueprintContainer extends StatelessWidget {
  final double width;
  final Widget child;
  final Color borderColor;
  final Color indicatorColor;

  const BlueprintContainer({
    super.key,
    required this.width,
    required this.child,
    this.borderColor = Colors.grey,
    this.indicatorColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWidthIndicator(),
        const SizedBox(height: 8),
        Container(
          width: width,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildWidthIndicator() {
    return SizedBox(
      width: width,
      height: 24,
      child: CustomPaint(
        painter: _WidthIndicatorPainter(
          width: width,
          color: indicatorColor,
        ),
      ),
    );
  }
}

class _WidthIndicatorPainter extends CustomPainter {
  final double width;
  final Color color;

  _WidthIndicatorPainter({
    required this.width,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(
      text: TextSpan(
        text: '${width.toInt()}px',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Calculate positions
    final lineY = size.height / 2;
    final textWidth = textPainter.width;
    final textHeight = textPainter.height;
    final textX = (size.width - textWidth) / 2;
    final textY = (size.height - textHeight) / 2;

    // Draw left line (from start to text)
    final leftLineEnd = textX - 4;
    if (leftLineEnd > 0) {
      canvas.drawLine(
        Offset(0, lineY),
        Offset(leftLineEnd, lineY),
        paint,
      );

      // Left arrow
      _drawArrowHead(canvas, paint, Offset(0, lineY), true);
    }

    // Draw right line (from text to end)
    final rightLineStart = textX + textWidth + 4;
    if (rightLineStart < size.width) {
      canvas.drawLine(
        Offset(rightLineStart, lineY),
        Offset(size.width, lineY),
        paint,
      );

      // Right arrow
      _drawArrowHead(canvas, paint, Offset(size.width, lineY), false);
    }

    // Draw text with background
    final textRect = Rect.fromLTWH(textX - 2, textY, textWidth + 4, textHeight);
    canvas.drawRRect(
      RRect.fromRectAndRadius(textRect, const Radius.circular(2)),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(textRect, const Radius.circular(2)),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    textPainter.paint(canvas, Offset(textX, textY));
  }

  void _drawArrowHead(Canvas canvas, Paint paint, Offset position, bool pointsRight) {
    const arrowSize = 4.0;
    final path = Path();

    if (pointsRight) {
      path.moveTo(position.dx, position.dy);
      path.lineTo(position.dx + arrowSize, position.dy - arrowSize / 2);
      path.lineTo(position.dx + arrowSize, position.dy + arrowSize / 2);
      path.close();
    } else {
      path.moveTo(position.dx, position.dy);
      path.lineTo(position.dx - arrowSize, position.dy - arrowSize / 2);
      path.lineTo(position.dx - arrowSize, position.dy + arrowSize / 2);
      path.close();
    }

    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _WidthIndicatorPainter || oldDelegate.width != width || oldDelegate.color != color;
  }
}
