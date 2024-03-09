import 'package:flutter/material.dart';

class MessagesBuilder extends StatefulWidget {
  const MessagesBuilder({
    super.key,
    required this.children,
  });
  final List<Widget> children;

  @override
  State<MessagesBuilder> createState() => _MessagesBuilderState();
}

class _MessagesBuilderState extends State<MessagesBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      reverse: true,
      shrinkWrap: true,
      children: widget.children,
    );
  }
}
