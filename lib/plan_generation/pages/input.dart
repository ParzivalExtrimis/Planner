import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:planner/plan_generation/api_handle.dart';
import 'package:planner/plan_generation/models/generated_plan_model.dart';
import 'package:planner/plan_generation/models/priority_model.dart';
import 'package:planner/plan_generation/models/prompt_parametric_model.dart';
import 'package:planner/plan_generation/pages/preview.dart';
import 'package:planner/utils/time_formatter.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';

class Input extends StatefulWidget {
  const Input({super.key});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  late Size _deviceSize;
  final _formKey = GlobalKey<FormState>();

  bool _requestSent = false;

  String _title = '';
  String _details = '';
  int _days = 2;
  int _hoursInDay = 1;
  PickedTime _preferredStartTime = PickedTime(h: 9, m: 0);
  PickedTime _preferredEndTime = PickedTime(h: 17, m: 0);
  Priority _priority = Priority.Normal;

  void _save(
      BuildContext context, Function(GeneratedPlanModel) navigate) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _requestSent = true;
      });

      print('''Title: $_title
              Days: $_days
              HoursInDay: $_hoursInDay
              PreferredStartTime: ${getFormattedTime(_preferredStartTime)} 
              PreferredEndTime: ${getFormattedTime(_preferredEndTime)} 
              Priority: $_priority
              Details: $_details''');

      // resolve api call to get a result object
      GeneratedPlanModel? plan = await ApiHandle.resolve(
        PromptParametricModel(
          title: _title,
          days: _days,
          hoursInDay: _hoursInDay,
          preferredStartTime: _preferredStartTime,
          preferredEndTime: _preferredEndTime,
          priority: _priority,
          details: _details,
        ),
      );
      // make preview page with the result object
      assert(plan != null, "Parser failed to make model from API response.");
      //log(plan!.debugPrint());
      navigate.call(plan!);
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          titleSpacing: 20,
          toolbarHeight: 70,
          title: Text(
            'New Topic',
            style: GoogleFonts.bebasNeue(
              fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title can\'t be empty.';
                      }
                      if (value.length < 3) {
                        return 'Title is too short';
                      }
                      return null;
                    },
                    onSaved: (val) => _title = val!,
                    decoration: InputDecoration(
                      hintText: 'I want to call it...',
                      hintStyle: GoogleFonts.bebasNeue(),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InteractiveSlider(
                    min: 1,
                    max: 7,
                    initialProgress: 0.2,
                    padding: const EdgeInsets.all(0),
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    focusedHeight: 50,
                    unfocusedHeight: 50,
                    unfocusedOpacity: 0.7,
                    centerIcon: Text(
                      _days != 1 ? '$_days days' : '$_days day',
                      style: GoogleFonts.bebasNeue(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onChanged: (value) => setState(() => _days = value.toInt()),
                  ),
                ),
                Center(
                  child: Text(
                    'I expect it to take about:',
                    style: GoogleFonts.bebasNeue(
                        fontSize:
                            Theme.of(context).textTheme.titleSmall!.fontSize),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    width: _deviceSize.width,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  'I want to work for',
                                  style: GoogleFonts.bebasNeue(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .fontSize,
                                  ),
                                ),
                              ),
                              CartStepperInt(
                                value: _hoursInDay,
                                size: 38,
                                style: CartStepperTheme.of(context).copyWith(
                                  activeForegroundColor:
                                      Theme.of(context).colorScheme.surface,
                                  textStyle: GoogleFonts.bebasNeue(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  activeBackgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.9),
                                  iconPlus: Icons.add_circle_rounded,
                                  iconMinus: Icons.remove_circle,
                                  iconTheme: IconThemeData(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                                didChangeCount: (count) {
                                  if (count < 1) {
                                    count = 1;
                                  } else if (count > 24) {
                                    count = 24;
                                  }
                                  setState(() => _hoursInDay = count);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  'Hrs / day',
                                  style: GoogleFonts.bebasNeue(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .fontSize,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      'This is a ',
                                      style: GoogleFonts.bebasNeue(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .fontSize,
                                      ),
                                    ),
                                  ),
                                  DropdownButton<Priority>(
                                    items:
                                        Priority.values.map((Priority value) {
                                      return DropdownMenuItem<Priority>(
                                        value: value,
                                        child: Text(
                                          value.name,
                                          style: GoogleFonts.bebasNeue(),
                                        ),
                                      );
                                    }).toList(),
                                    value: _priority,
                                    borderRadius: BorderRadius.circular(8),
                                    alignment: Alignment.center,
                                    icon: const Icon(null),
                                    onChanged: (priority) {
                                      if (priority == null) return;
                                      setState(() {
                                        _priority = priority;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      'Priority',
                                      style: GoogleFonts.bebasNeue(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .fontSize,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              'I\'d like to work between:',
                              style: GoogleFonts.bebasNeue(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .fontSize),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TimePicker(
                                initTime: _preferredStartTime,
                                endTime: _preferredEndTime,
                                height: 170,
                                width: 170,
                                decoration: TimePickerDecoration(
                                  sweepDecoration: TimePickerSweepDecoration(
                                    pickerStrokeWidth: 20,
                                    pickerColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  baseColor: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  initHandlerDecoration:
                                      TimePickerHandlerDecoration(
                                          showHandlerOutter: false,
                                          showHandler: false),
                                  endHandlerDecoration:
                                      TimePickerHandlerDecoration(
                                          showHandlerOutter: false,
                                          showHandler: false),
                                ),
                                onSelectionChange: (start, end, _) {
                                  setState(() {
                                    _preferredStartTime = start;
                                    _preferredEndTime = end;
                                  });
                                },
                                onSelectionEnd: (start, end, _) {},
                                child: Center(
                                  child: Text(
                                    '${getFormattedTime(_preferredStartTime)}\n${getFormattedTime(_preferredEndTime)}',
                                    style: GoogleFonts.bebasNeue(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Some details of your requirements must be entered';
                    }
                    if (value.length < 10) {
                      return 'Not enough details added';
                    }
                    return null;
                  },
                  onSaved: (val) => _details = val!,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 8,
                  decoration: InputDecoration(
                    hintText: 'Here are the details...',
                    hintStyle: GoogleFonts.bebasNeue(),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                  child: ElevatedButton(
                    onPressed: () => _save(
                      context,
                      (GeneratedPlanModel plan) {
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Preview(
                                plan: plan,
                              ), // result obj when api class written
                            ),
                          );
                        }
                      },
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.8),
                      foregroundColor: Theme.of(context).colorScheme.surface,
                    ),
                    child: _requestSent
                        ? const CircularProgressIndicator()
                        : const Text('Done'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
