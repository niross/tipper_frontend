import 'package:flutter/material.dart';
import 'constants.dart' as constants;

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: const [
        Icon(
          Icons.delete_sweep,
          size: 50,
        ),
        Text(
          constants.mainHeader,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 45
          ),
        ),
      ],
    );
  }
}
