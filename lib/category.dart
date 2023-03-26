import 'package:app/converterRoute.dart';
import 'package:app/unit.dart';
import 'package:flutter/material.dart';

const _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 2);

/// A [Category] keeps track of a list of [Unit]s.
class Category extends StatelessWidget {
  final String name;
  final ColorSwatch color;
  final IconData iconLocation;
  final List<Unit> units;

  /// Information about a [Category].
  ///
  /// A [Category] saves the name of the Category (e.g. 'Length'), a list of its
  /// its color for the UI, units for conversions (e.g. 'Millimeter', 'Meter'),
  /// and the icon that represents it (e.g. a ruler).
  const Category({
    required this.name,
    required this.color,
    required this.iconLocation,
    required this.units,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: _rowHeight,
        child: InkWell(
          borderRadius: _borderRadius,
          splashColor: color,
          highlightColor: color,
          onTap: () => _navigateToConverter(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    iconLocation,
                    size: 60.0,
                  ),
                ),
                Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToConverter(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1.0,
            title: Text(
              name,
              style: Theme.of(context).textTheme.headline5,
            ),
            centerTitle: true,
            backgroundColor: color,
          ),
          body: ConverterRoute(
            color: color,
            units: units,
          ),
        );
      }),
    );
  }
}
