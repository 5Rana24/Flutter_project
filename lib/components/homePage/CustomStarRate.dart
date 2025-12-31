import 'package:flutter/material.dart';

class CustomStarRate extends StatefulWidget {
  double? averageRate;
  CustomStarRate({required this.averageRate});
  State<CustomStarRate> createState() => _CustomStarRate();
}

class _CustomStarRate extends State<CustomStarRate> {
  double iconsSize = 18;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        if (widget.averageRate != null) {
          if (i < widget.averageRate!.floor())
            return Icon(Icons.star, color: Colors.yellow, size: iconsSize);
          else if (i < widget.averageRate!)
            return Icon(Icons.star_half, color: Colors.yellow, size: iconsSize);
          else
            return Icon(Icons.star, color: Colors.grey, size: iconsSize);
        } else
          return Icon(Icons.star, color: Colors.grey, size: iconsSize);
      }),
    );
  }
}

double getAverageRate(List<double> rates) {
  return rates.isEmpty ? 0 : rates.reduce((a, b) => a + b) / rates.length;
}
