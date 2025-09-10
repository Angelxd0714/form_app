import 'package:flutter/material.dart';

class CountryStateCityPicker extends StatefulWidget {
  final ValueChanged<String>? onCountryChanged;
  final ValueChanged<String>? onStateChanged;
  final ValueChanged<String>? onCityChanged;

  const CountryStateCityPicker({
    super.key,
    this.onCountryChanged,
    this.onStateChanged,
    this.onCityChanged,
  });

  @override
  _CountryStateCityPickerState createState() => _CountryStateCityPickerState();
}

class _CountryStateCityPickerState extends State<CountryStateCityPicker> {
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;

  // Sample data - in a real app, this would come from an API or local database
  final Map<String, Map<String, List<String>>> _locationData = {
    'Colombia': {
      'Antioquia': ['Medellín', 'Bello', 'Itagüí', 'Envigado'],
      'Cundinamarca': ['Bogotá', 'Soacha', 'Zipaquirá', 'Chía'],
      'Valle del Cauca': ['Cali', 'Palmira', 'Buenaventura', 'Tuluá'],
    },
    'México': {
      'Ciudad de México': ['Álvaro Obregón', 'Benito Juárez', 'Coyoacán'],
      'Jalisco': ['Guadalajara', 'Zapopan', 'Tlaquepaque'],
      'Nuevo León': ['Monterrey', 'San Pedro Garza García', 'San Nicolás'],
    },
    'España': {
      'Madrid': ['Madrid', 'Alcalá de Henares', 'Alcorcón'],
      'Cataluña': ['Barcelona', 'L\'Hospitalet de Llobregat', 'Badalona'],
      'Andalucía': ['Sevilla', 'Málaga', 'Córdoba'],
    },
  };

  List<String> get _countries => _locationData.keys.toList();
  List<String> get _states => _selectedCountry != null
      ? _locationData[_selectedCountry]!.keys.toList()
      : [];
  List<String> get _cities => _selectedCountry != null &&
          _selectedState != null &&
          _locationData[_selectedCountry]!.containsKey(_selectedState!)
      ? _locationData[_selectedCountry!]![_selectedState!]!
      : [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDropdown(
          value: _selectedCountry,
          hint: 'Selecciona un país',
          items: _countries,
          onChanged: (value) {
            setState(() {
              _selectedCountry = value;
              _selectedState = null;
              _selectedCity = null;
            });
            widget.onCountryChanged?.call(value!);
          },
        ),
        const SizedBox(height: 12),
        _buildDropdown(
          value: _selectedState,
          hint: 'Selecciona un departamento/estado',
          items: _states,
          onChanged: (value) {
            if (_selectedCountry != null) {
              setState(() {
                _selectedState = value;
                _selectedCity = null;
              });
              widget.onStateChanged?.call(value!);
            }
          },
        ),
        const SizedBox(height: 12),
      _buildDropdown(
  value: _selectedCity,
  hint: 'Selecciona una ciudad/municipio',
  items: _cities,
  onChanged: _selectedState == null
      ? (value) {}  // Provide a no-op function instead of null
      : (value) {
          setState(() {
            _selectedCity = value;
          });
          widget.onCityChanged?.call(value!);
        },
),
      ],
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      ),
      items: [
        DropdownMenuItem(
          value: null,
          child: Text(
            hint,
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
        ),
        ...items.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            )),
      ],
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo es obligatorio';
        }
        return null;
      },
      isExpanded: true,
    );
  }
}
