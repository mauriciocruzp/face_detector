import 'package:flutter/material.dart';

class DetectedObjectBox extends StatelessWidget {
  final double x, y, w, h;
  final String label;
  final double confidence, width, height;

  const DetectedObjectBox({
    super.key,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.label,
    required this.confidence,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (y) * height,
      right: (x) * width,
      child: Container(
        width: (w) * width,
        height: (h) * height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.blue,
            width: 2.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: const Color.fromARGB(255, 163, 238, 169),
              child: Text('$label ${(confidence * 100).toStringAsFixed(2)}'),
            ),
          ],
        ),
      ),
    );
  }
}