import 'package:flutter/material.dart';

class AuthGradientButton extends StatefulWidget {
  const AuthGradientButton(
      {super.key,
      required this.icon,
      required this.buttonText,
      required this.onPress, required this.iconColor});

  final IconData icon;
  final Color iconColor;
  final Text buttonText;
  final VoidCallback onPress;

  @override
  State<AuthGradientButton> createState() => _AuthGradientButtonState();
}

class _AuthGradientButtonState extends State<AuthGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _colorTween = _controller.drive(ColorTween(
      begin: Colors.brown.shade600,
      end: Colors.brown.shade300,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  colors: [_colorTween.value!, Colors.brown],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight),
            ),
            child: ElevatedButton.icon(
              iconAlignment: IconAlignment.end,
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                fixedSize: const Size(
                  400,
                  60,
                ),
              ),
              onPressed: widget.onPress,
              icon: Icon(
                widget.icon,
                color: widget.iconColor,
              ),
              label: widget.buttonText,
            ),
          );
        });
  }
}
