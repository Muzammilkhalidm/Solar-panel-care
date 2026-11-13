import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/ui_helpers.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/utils/validators.dart';
import '../../state/panels_provider.dart';

/// Register a new solar plate + its IoT device.
/// Fixed flow: loading state, explicit error reporting and success pop.
class AddPanelScreen extends StatefulWidget {
  const AddPanelScreen({super.key});

  @override
  State<AddPanelScreen> createState() => _AddPanelScreenState();
}

class _AddPanelScreenState extends State<AddPanelScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _submitting = false;

  String _model = _models.first.model;
  double _watts = 550;

  static const List<({String model, double watts})> _models = [
    (model: 'Longi Himo 6 580W', watts: 580),
    (model: 'Jinko Tiger Neo 550W', watts: 550),
    (model: 'Trina Vertex 500W', watts: 500),
    (model: 'Canadian Solar 445W', watts: 445),
    (model: 'JA Solar 430W', watts: 430),
    (model: 'Custom / Other', watts: 400),
  ];

  @override
  void dispose() {
    _name.dispose();
    _location.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Hide the keyboard first so validation messages are visible.
    FocusScope.of(context).unfocus();

    if (!(_form.currentState?.validate() ?? false)) {
      AppSnackBar.warning(
        'Please fill Plate name and Location to register.',
      );
      return;
    }
    if (_submitting) return;
    setState(() => _submitting = true);

    try {
      final panels = context.read<PanelsProvider>();
      final created = await panels.addPanelRecord(
        name: _name.text.trim(),
        model: _model,
        ratedWatts: _watts,
        location: _location.text.trim(),
      );
      if (!mounted) return;
      if (created != null) {
        AppSnackBar.success(
            '${created.name} registered with IoT device ${created.deviceId}');
        Navigator.of(context).maybePop();
      } else {
        AppSnackBar.error('Could not register the plate. Please try again.');
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.error(
        'Registration failed: $e',
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final panels = context.watch<PanelsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Register Solar Plate')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 26),
        child: Form(
          key: _form,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info banner with the auto-generated ids.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7E2D).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFFF7E2D).withOpacity(0.30),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFC65C), Color(0xFFFF7E2D)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.solar_power,
                          size: 20, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Next plate id: SP-${(panels.total + 1).toString().padLeft(3, '0')}',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: p.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'A unique IoT device id is generated automatically '
                            'and the plate starts reporting within seconds.',
                            style: TextStyle(
                              fontSize: 11,
                              color: p.textSecondary,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              AppTextField(
                controller: _name,
                label: 'Plate name',
                hint: 'e.g. Rooftop H1',
                prefixIcon: Icons.solar_power,
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.required(v, field: 'Plate name'),
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _location,
                label: 'Location / side',
                hint: 'e.g. Rooftop West',
                prefixIcon: Icons.place_outlined,
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.required(v, field: 'Location'),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _model,
                decoration: const InputDecoration(
                  labelText: 'Panel model',
                  prefixIcon: Icon(Icons.category_outlined, size: 21),
                ),
                items: _models
                    .map((m) => DropdownMenuItem<String>(
                          value: m.model,
                          child: Text(m.model,
                              style: TextStyle(
                                  fontSize: 13.5, color: p.textPrimary)),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    _model = v;
                    final match =
                        _models.firstWhere((m) => m.model == v);
                    _watts = match.watts;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Rated power: ${_watts.toStringAsFixed(0)} W',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: p.textPrimary,
                ),
              ),
              Slider(
                value: _watts,
                min: 300,
                max: 700,
                divisions: 40,
                label: '${_watts.toStringAsFixed(0)} W',
                onChanged: _submitting ? null : (v) => setState(() => _watts = v),
              ),
              const SizedBox(height: 14),
              AppButton(
                label: 'Register Plate',
                icon: Icons.add_circle_outline,
                loading: _submitting,
                onPressed: _submitting ? null : _submit,
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'The plate appears instantly in My Plates and on the dashboard.',
                  style: TextStyle(fontSize: 10.5, color: p.textFaint),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
