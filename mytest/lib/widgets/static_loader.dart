import 'package:flutter/material.dart';

class StaticLoader extends StatelessWidget {
  const StaticLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        child: Text(
          '読み込み中...',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
