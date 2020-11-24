import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_poetry_text/dartui/vertical_paragraph.dart';

class VerticalParagraphBuilder {
  VerticalParagraphBuilder(ui.ParagraphStyle style) {
    _paragraphStyle = style;
  }

  ui.ParagraphStyle _paragraphStyle;
  ui.TextStyle _textStyle;
  String _text = '';

  static final _defaultParagraphStyle = ui.ParagraphStyle(
    textAlign: TextAlign.left,
    textDirection: TextDirection.ltr,
    fontSize: 30,
  );

  static final _defaultTextStyle = ui.TextStyle(
    color: Color(0xFF000000), // opaque black
    textBaseline: ui.TextBaseline.alphabetic,
    fontSize: 30,
  );

  set textStyle(TextStyle style) {
    _textStyle = style.getTextStyle();
  }

  set text(String text) {
    _text = text;
  }

  VerticalParagraph build() {
    if (_paragraphStyle == null) {
      _paragraphStyle = _defaultParagraphStyle;
    }
    if (_textStyle == null) {
      _textStyle = _defaultTextStyle;
    }
    return VerticalParagraph(_paragraphStyle, _textStyle, _text);
  }
}