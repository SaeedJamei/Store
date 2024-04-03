import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/locales.g.dart';

class PriceRangeSlider extends StatelessWidget {
  const PriceRangeSlider({
    required this.values,
    required this.min,
    required this.max,
    required this.onChange,
    required this.onFilterTap,
    required this.onRemoveFilterTap,
    super.key,
  });

  final double max;
  final double min;
  final RangeValues values;
  final Function onChange;
  final Function onFilterTap;
  final Function onRemoveFilterTap;

  @override
  Widget build(BuildContext context) => Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                RangeSlider(
                  values: values,
                  onChanged: (newValues) => onChange(newValues),
                  min: min,
                  max: max,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        values.start.round().toString(),
                        overflow: TextOverflow.ellipsis,
                      )),
                      Expanded(
                          child: Text(
                        values.end.round().toString(),
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                      ))
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      onFilterTap();
                      Navigator.of(context).pop();
                    },
                    child: Text(LocaleKeys.filter.tr)),
                IconButton(
                  onPressed: () {
                    onRemoveFilterTap();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.highlight_remove),
                  color: Colors.red,
                ),
              ],
            )
          ],
        ),
      );
}
