import 'package:flutter/material.dart';

class StarRatingWidget extends StatefulWidget {
  final int maxRating;
  final Function(int) onRatingSelected;

  const StarRatingWidget(
      {Key? key, this.maxRating = 5, required this.onRatingSelected})
      : super(key: key);

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  int _currentRating = 0;

  void _setRating(int rating) {
    setState(() {
      _currentRating = rating;
    });
    widget.onRatingSelected(rating);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxRating, (index) {
        return GestureDetector(
          onTap: () => _setRating(index + 1),
          child: Icon(
            index < _currentRating
                ? Icons.star_rounded
                : Icons.star_border_rounded,
            color: index < _currentRating
                ? Color.fromARGB(255, 252, 233, 62)
                : Color.fromARGB(255, 121, 121, 121),
            size: 25.0,
          ),
        );
      }),
    );
  }
}
