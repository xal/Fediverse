import 'package:fedi/app/ui/fedi_text_styles.dart';
import 'package:flutter/cupertino.dart';

class FediFormColumnLabel extends StatelessWidget {
  final String text;

  FediFormColumnLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: FediTextStyles.mediumTallGrey,
      );
}