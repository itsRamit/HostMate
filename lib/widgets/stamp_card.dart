import 'dart:math';

import 'package:flutter/material.dart';
import 'package:host_mate/models/experience.dart';

class StampCard extends StatelessWidget {
  final Experience data;
  final bool selected;
  final VoidCallback onTap;
  final int index;

  const StampCard({
    super.key,
    required this.data,
    required this.selected,
    required this.onTap,
    required this.index,
  });

  double _tiltForIndex(int index) {
    // left, right, none -> repeat
    const pattern = [-3, 3, 0];
    return (pattern[index % 3] * pi) / 180.0;
  }

  static const _grayMatrix = <double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0,      0,      0,      1, 0,
  ];

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final tilt = _tiltForIndex(index);

    Widget image() => Padding(
          padding: const EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: (data.imageUrl.isNotEmpty) ? Image.network(
              data.imageUrl,
              fit: BoxFit.cover,
            ) : Image.asset('assets/images/no_img.png'),
          ),
        );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        padding: EdgeInsets.all(4),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: w*0.29,
        height: w*0.29,
        transformAlignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(0.0, selected ? -6.0 : 0.0)
          ..rotateZ(selected ? 0 : tilt),
        child: ClipPath(
          clipper: StampClipper(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white.withOpacity(0.95),
                width: selected ? 3 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ✨ Reliable grayscale: swap between two trees
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  layoutBuilder: (currentChild, previousChildren) => Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  ),
                  child: selected
                      ? KeyedSubtree(
                          key: const ValueKey('color'),
                          child: image(),
                        )
                      : KeyedSubtree(
                          key: const ValueKey('gray'),
                          child: ColorFiltered(
                            colorFilter:
                                const ColorFilter.matrix(_grayMatrix),
                            child: image(),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StampClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double radius = 4.0;
    const double spacing = 10.0;
    Path path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    Path holes = Path();

    for (double x = 0; x <= size.width; x += spacing) {
      holes.addOval(Rect.fromCircle(center: Offset(x, 0), radius: radius));
      holes.addOval(Rect.fromCircle(center: Offset(x, size.height), radius: radius));
    }
    for (double y = 0; y <= size.height; y += spacing) {
      holes.addOval(Rect.fromCircle(center: Offset(0, y), radius: radius));
      holes.addOval(Rect.fromCircle(center: Offset(size.width, y), radius: radius));
    }

    return Path.combine(PathOperation.difference, path, holes);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}