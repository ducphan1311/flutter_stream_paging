import 'package:flutter/material.dart';

class PagingDefaultErrorWidget extends StatefulWidget {
  static const path = '/error_widget';
  const PagingDefaultErrorWidget(
      {Key? key, required this.errorMessage, this.onPressed})
      : super(key: key);
  final String errorMessage;
  final Function()? onPressed;

  @override
  State<PagingDefaultErrorWidget> createState() =>
      _PagingDefaultErrorWidgetState();
}

class _PagingDefaultErrorWidgetState extends State<PagingDefaultErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.errorMessage),
          const SizedBox(
            height: 16,
          ),
          TextButton(
              onPressed: widget.onPressed, child: const Text('Try Again'))
        ],
      ),
    );
  }
}
