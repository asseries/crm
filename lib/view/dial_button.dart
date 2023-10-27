import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/utils.dart';

class DialButton extends StatefulWidget {
  final String number;
  final String symbol;
  final Function onClick;
  final Function? longClick;
  const DialButton({Key? key, required this.number, required this.symbol, required this.onClick,this.longClick}) : super(key: key);

  @override
  State<DialButton> createState() => _DialButtonState();
}

class _DialButtonState extends State<DialButton> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        highlightColor: AppColors.COLOR_PRIMARY.withOpacity(.2),
        onTap: () {
          vibrateLight();
          widget.onClick();
        },
        onLongPress: ()=>widget.longClick!(),
        child: Container(
          height: 70,
          width: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
          ),

          child: Column(
            children: [
              Text(
                widget.number,
                style: asTextStyle(
                  fontFamily: "p_semi",
                  size: 24,
                ),
              ),
              Text(
                widget.symbol,
                style: asTextStyle(
                  fontFamily: "p_reg",
                  size: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
