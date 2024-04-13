import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///Custom Switch Button example
class CustomSwitchButton extends StatefulWidget {
  ///Constructor of Switch Button
  const CustomSwitchButton({
    required this.onTap,
    required this.onChanged,
    super.key,
    this.value = false,
    this.width = 130,
    this.textOff = 'Off',
    this.textOn = 'On',
    this.textSize = 14.0,
    this.colorOn = Colors.greenAccent,
    this.colorOff = Colors.redAccent,
    this.widgetOff = const Icon(Icons.power),
    this.widgetOn = const Icon(Icons.check),
    this.animationDuration = const Duration(milliseconds: 600),
    this.textOffColor = Colors.white,
    this.textOnColor = Colors.black,
  });
  @required

  ///value of the switch button animate
  final bool value;

  ///width of the widget
  final double width;

  ///onChange callback function
  final OnChangeCallback onChanged;

  ///Off situation text
  final String textOff;

  ///Off situation text color
  final Color textOffColor;

  ///On situation text
  final String textOn;

  ///On situation text color
  final Color textOnColor;

  ///On situation widget background color
  final Color colorOn;

  ///Off situation widget background color
  final Color colorOff;

  ///Text size of the widget
  final double textSize;

  ///Animation duration
  final Duration animationDuration;

  ///On situation widget [Icon]
  final Widget widgetOn;

  ///Off situation widget [Icon]
  final Widget widgetOff;

  ///On Tap Function of the widget
  final OnTapCallback onTap;

  @override
  // ignore: library_private_types_in_public_api
  _RollingSwitchState createState() => _RollingSwitchState();
}

final class _RollingSwitchState extends State<CustomSwitchButton>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  late bool turnState;

  double value = 0;

  @override
  void dispose() {
    //Ensure to dispose animation controller
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animationController.addListener(() {
      setState(() {
        value = animation.value;
      });
    });
    turnState = widget.value;

    // Executes a function only one time after the layout is completed.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (turnState) {
          animationController.forward();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Color transition animation
    final transitionColor = Color.lerp(widget.colorOff, widget.colorOn, value);

    return GestureDetector(
      onTap: () {
        _action();
        widget.onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        width: widget.width,
        decoration: BoxDecoration(
          color: transitionColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Stack(
          children: <Widget>[
            Transform.translate(
              offset: isRTL(context)
                  ? Offset(-10 * value, 0)
                  : Offset(10 * value, 0), //original
              child: Opacity(
                opacity: (1 - value).clamp(0.0, 1.0),
                child: Container(
                  padding: isRTL(context)
                      ? const EdgeInsets.only(left: 10)
                      : const EdgeInsets.only(right: 10),
                  alignment: isRTL(context)
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  height: 40,
                  child: Text(
                    widget.textOff,
                    style: TextStyle(
                      color: widget.textOffColor,
                      fontWeight: FontWeight.bold,
                      fontSize: widget.textSize,
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: isRTL(context)
                  ? Offset(-10 * (1 - value), 0)
                  : Offset(10 * (1 - value), 0), //original
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Container(
                  padding: isRTL(context)
                      ? const EdgeInsets.only(right: 5)
                      : const EdgeInsets.only(left: 5),
                  alignment: isRTL(context)
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  height: 40,
                  child: Text(
                    widget.textOn,
                    style: TextStyle(
                      color: widget.textOnColor,
                      fontWeight: FontWeight.bold,
                      fontSize: widget.textSize,
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: isRTL(context)
                  ? Offset((-widget.width + 50) * value, 0)
                  : Offset((widget.width - 50) * value, 0),
              child: Transform.rotate(
                angle: 0,
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Opacity(
                          opacity: (1 - value).clamp(0.0, 1.0),
                          child: Container(
                            color: transitionColor,
                            child: widget.widgetOff,
                          ),
                        ),
                      ),
                      Center(
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Container(
                            color: transitionColor,
                            child: widget.widgetOn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _action() {
    _determine();
  }

  void _determine() {
    setState(() {
      turnState = !turnState;
      turnState ? animationController.forward() : animationController.reverse();
      widget.onChanged(value: turnState);
    });
  }
}

/// Determines if the text direction is right-to-left
bool isRTL(BuildContext context) {
  return Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode);
}

/// OnChangeCallback function
typedef OnChangeCallback = void Function({required bool value});

/// OnTapCallback function
typedef OnTapCallback = void Function();
