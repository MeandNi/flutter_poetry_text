import 'package:flutter/widgets.dart';
import 'package:flutter_poetry_text/widget/render_vertical_text.dart';

class PoetryText extends LeafRenderObjectWidget {
  const PoetryText({
    Key key,
    this.text,
  }) : super(key: key);

  final TextSpan text;

  @override
  RenderVerticalText createRenderObject(BuildContext context) {
    return RenderVerticalText(text);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderVerticalText renderObject) {
    renderObject.text = text;
  }
}
