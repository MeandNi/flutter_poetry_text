/*
 * Copyright (c) 2019 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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
