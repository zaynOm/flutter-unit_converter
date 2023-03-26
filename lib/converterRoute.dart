import 'package:app/unit.dart';
import 'package:flutter/material.dart';

const _padding = EdgeInsets.all(16.0);

class ConverterRoute extends StatefulWidget {
  final Color color;
  final List<Unit> units;

  const ConverterRoute({Key? key, required this.color, required this.units})
      : super(key: key);

  @override
  State<ConverterRoute> createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  Unit? _inputUnit;
  Unit? _outputUnit;
  double? _inputValue;
  String _outputValue = '';
  List<DropdownMenuItem>? _unitMenuItems;
  bool _showValidationError = false;

  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems();
    _setDefaults();
  }

  void _createDropdownMenuItems() {
    var newItems = <DropdownMenuItem>[];
    for (var unit in widget.units) {
      newItems.add(DropdownMenuItem(
        value: unit.name,
        child: Text(
          unit.name!,
          softWrap: true,
        ),
      ));
    }
    setState(() {
      _unitMenuItems = newItems;
    });
  }

  void _setDefaults() {
    setState(() {
      _inputUnit = widget.units[0];
      _outputUnit = widget.units[1];
    });
  }

  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  void _updateConversion() {
    setState(() {
      _outputValue = _format(
          _inputValue! * (_outputUnit!.conversion! / _inputUnit!.conversion!));
    });
  }

  void _updateInputValue(String input) {
    setState(() {
      if (input.isEmpty) {
        _outputValue = '';
      } else {
        try {
          final inputDouble = double.parse(input);
          _showValidationError = false;
          _inputValue = inputDouble;
          _updateConversion();
        } on Exception catch (e) {
          print('Error: $e');
          _showValidationError = true;
        }
      }
    });
  }

  Unit? _getUnit(String? unitName) {
    return widget.units.firstWhere(
      (Unit unit) {
        return unit.name == unitName;
      },
    );
  }

  void _updateFromConversion(dynamic unitName) {
    setState(() {
      _inputUnit = _getUnit(unitName);
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  void _updateToConversion(dynamic unitName) {
    setState(() {
      _outputUnit = _getUnit(unitName);
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  Widget _createDropdown(
      String? currentValue, ValueChanged<dynamic> onChanged) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[400]!,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
            child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            value: currentValue,
            items: _unitMenuItems,
            onChanged: onChanged,
            style: Theme.of(context).textTheme.headline6,
          ),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final input = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            style: Theme.of(context).textTheme.headline4,
            decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.headline4,
              errorText: _showValidationError ? 'Invalid number entred' : null,
              labelText: 'Input',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: _updateInputValue,
          ),
          _createDropdown(_inputUnit!.name, _updateFromConversion),
        ],
      ),
    );

    const arrows = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    final output = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputDecorator(
            child: Text(
              _outputValue,
              style: Theme.of(context).textTheme.headline4,
            ),
            decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.headline4,
              labelText: 'Output',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
          _createDropdown(_outputUnit!.name, _updateToConversion),
        ],
      ),
    );

    final converter = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        input,
        arrows,
        output,
      ],
    );

    return Padding(
      padding: _padding,
      child: converter,
    );
  }
}

/* final _textController = TextEditingController();
        final input = Container(
          child: Column(
            children: [
              TextField(
                controller: _textController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Input',
                ),
              ),
              DropdownButton(
                items: <String>
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ); */

/* final unitWidgets = widget.units.map((Unit unit) {
      return Container(
        color: widget.color,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              unit.name!,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              'Conversion: ${unit.conversion}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      );
    }).toList();

    return ListView(
      children: unitWidgets,
    );
  } */
