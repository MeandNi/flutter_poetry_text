import 'package:flutter/painting.dart';
import 'package:flutter_poetry_text/dartui/vertical_paragraph.dart';
import 'package:flutter_poetry_text/dartui/vertical_paragraph_builder.dart';
import 'package:flutter_poetry_text/model/vertical_paragraph_constraints.dart';

class VerticalTextPainter {
  VerticalTextPainter({TextSpan text}) : _text = text;

  VerticalParagraph _paragraph;
  bool _needsLayout = true;

  TextSpan get text => _text;
  TextSpan _text;

  set text(TextSpan value) {
    if (_text == value) return;
    _text = value;
    _paragraph = null;
    _needsLayout = true;
  }

  double _applyFloatingPointHack(double layoutValue) {
    return layoutValue.ceilToDouble();
  }

  double get minIntrinsicHeight {
    return _applyFloatingPointHack(_paragraph.minIntrinsicHeight);
  }

  double get maxIntrinsicHeight {
    return _applyFloatingPointHack(_paragraph.maxIntrinsicHeight);
  }

  double get width {
    return _applyFloatingPointHack(_paragraph.width);
  }

  double get height {
    return _applyFloatingPointHack(_paragraph.height);
  }

  Size get size {
    return Size(width, height);
  }

  double _lastMinHeight;
  double _lastMaxHeight;

  void layout({double minHeight = 0.0, double maxHeight = double.infinity}) {
    if (!_needsLayout &&
        minHeight == _lastMinHeight &&
        maxHeight == _lastMaxHeight) return;
    _needsLayout = false;
    if (_paragraph == null) {
      final VerticalParagraphBuilder builder = VerticalParagraphBuilder(null);
      _applyTextSpan(builder, _text);
      _paragraph = builder.build();
    }
    _lastMinHeight = minHeight;
    _lastMaxHeight = maxHeight;
    _paragraph.layout(VerticalParagraphConstraints(height: maxHeight));
    if (minHeight != maxHeight) {
      final double newHeight = maxIntrinsicHeight.clamp(minHeight, maxHeight);
      if (newHeight != height)
        _paragraph.layout(VerticalParagraphConstraints(height: newHeight));
    }
  }

  void _applyTextSpan(VerticalParagraphBuilder builder, TextSpan textSpan) {
    final style = textSpan.style;
    final text = textSpan.text;
    final bool hasStyle = style != null;
    if (hasStyle) {
      builder.textStyle = style;
    }
    if (text != null) {
      builder.text = text;
    }
  }

  void paint(Canvas canvas, Offset offset) {
    _paragraph.draw(canvas, offset);
  }
}
