import 'package:flutter/material.dart';
import 'package:flutter_stream_paging/ui/widgets/footer_tile.dart';

class NewPageProgressIndicator extends StatelessWidget {
  const NewPageProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const FooterTile(
        child: CircularProgressIndicator(),
      );
}
