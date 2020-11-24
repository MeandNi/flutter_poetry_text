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

import 'package:flutter/rendering.dart';
import 'package:flutter_poetry_text/dartui/vertical_text_painter.dart';

class RenderVerticalText extends RenderBox {
  RenderVerticalText(TextSpan text)
      : _textPainter = VerticalTextPainter(text: text);

  final VerticalTextPainter _textPainter;

  TextSpan get text => _textPainter.text;

  set text(TextSpan value) {
    switch (_textPainter.text.compareTo(value)) {
      case RenderComparison.identical:
      case RenderComparison.metadata:
        return;
      case RenderComparison.paint:
        _textPainter.text = value;
        markNeedsPaint();
        break;
      case RenderComparison.layout:
        _textPainter.text = value;
        markNeedsLayout();
        break;
    }
  }

  void _layoutText({
    double minHeight = 0.0,
    double maxHeight = double.infinity,
  }) {
    _textPainter.layout(
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }

  void _layoutTextWithConstraints(BoxConstraints constraints) {
    _layoutText(
      minHeight: constraints.minHeight,
      maxHeight: constraints.maxHeight,
    );
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    _layoutText();
    return _textPainter.minIntrinsicHeight;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    _layoutText();
    return _textPainter.maxIntrinsicHeight;
  }

  double _computeIntrinsicWidth(double height) {
    _layoutText(minHeight: height, maxHeight: height);
    return _textPainter.width;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _computeIntrinsicWidth(height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _computeIntrinsicWidth(height);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(!debugNeedsLayout);
    assert(constraints != null);
    assert(constraints.debugAssertIsValid());
    _layoutTextWithConstraints(constraints);
    // Since the text is rotated it doesn't make sense to use the rotated
    // text baseline because this is used for aligning with other widgets.
    // Instead we will return the base of the widget.
    return _textPainter.height;
  }

  @override
  void performLayout() {
    _layoutTextWithConstraints(constraints);
    final Size textSize = _textPainter.size;
    size = constraints.constrain(textSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _textPainter.paint(context.canvas, offset);
  }
}
