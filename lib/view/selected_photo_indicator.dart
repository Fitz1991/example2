import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectedPhotoIndicator extends StatelessWidget {
  final int numberOfLines;
  final int photoIndex;
  final Color colorActivePhoto;
  final Color colorInActivePhoto;
  BuildContext _context;

  SelectedPhotoIndicator(
      {Key key,
      this.numberOfLines,
      this.photoIndex,
      this.colorActivePhoto,
      this.colorInActivePhoto})
      : super(key: key);

  _inactivePhoto() {
    return new Container(
      child: Padding(
        padding: EdgeInsets.only(left: 1),
        child: Opacity(
          opacity: 0.50,
          child: Container(
            height: 3,
            width: (MediaQuery.of(_context).size.width - 30) / numberOfLines,
            decoration: BoxDecoration(
                color: colorInActivePhoto,
                borderRadius: BorderRadius.circular(4)),
          ),
        ),
      ),
    );
  }

  _activePhoto() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Container(
          height: 3,
          width: (MediaQuery.of(_context).size.width - 30) / numberOfLines,
          decoration: BoxDecoration(
              color: colorActivePhoto,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(color: Colors.green, spreadRadius: 0, blurRadius: 2)
              ]),
        ),
      ),
    );
  }

  List<Widget> _buildLines() {
    List<Widget> dots = [];
    for (int i = 0; i < numberOfLines; i++) {
      dots.add(i == photoIndex ? _activePhoto() : _inactivePhoto());
    }
    return dots;
  }

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildLines(),
      ),
    );
  }
}
