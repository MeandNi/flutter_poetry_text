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

/// This class finds locations in a string of text where it would be appropriate
/// to break the line so that it can soft wrap. It uses a very simplistic
/// algorithm that will break the text between a space character and a non-space
/// character. This is enough for common purposes but it does not conform to
/// the Unicode standards for text breaking locations. Minikin in Flutter's
/// LibTxt contains a LineBreaker class, but at the time of this writing it has
/// not been exposed in dart:ui.
///
/// See the following links for more information:
///
/// * https://github.com/flutter/flutter/issues/35994
/// * https://github.com/flutter/engine/blob/a4abfb2333afe16675db0709d18a6e918b0123da/third_party/txt/src/minikin/LineBreaker.cpp
class LineBreaker {

  String _text;
  List<int> _breaks;

  set text(String text) {
    if (text == _text) {
      return;
    }
    _text = text;
    _breaks = null;
  }

  // returns the number of breaks
  int computeBreaks() {
    if (_breaks != null) {
      return _breaks.length;
    }
    _breaks = [];

    for (int i = 1; i < _text.length; i++) {
      if (isBreakChar(_text[i - 1]) && !isBreakChar(_text[i])) {
        _breaks.add(i);
      }
    }

    return _breaks.length;
  }

  List<int> get breaks => _breaks;

  static const space = '，';
  bool isBreakChar(String codeUnit) {
    return codeUnit == space;
  }
}
