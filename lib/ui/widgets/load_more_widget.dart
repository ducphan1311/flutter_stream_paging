import 'package:flutter/cupertino.dart';

class LoadMoreWidget extends StatelessWidget {
  const LoadMoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      alignment: Alignment.center,
      child: const CupertinoActivityIndicator(),
    );
  }
}
