import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planner/plan_generation/models/generated_plan_model.dart';
import 'package:planner/plan_generation/widgets/preview_tile.dart';
import 'package:planner/widgets/suffix_icon_text_field.dart';

class Preview extends StatefulWidget {
  const Preview({super.key, required this.plan});
  final GeneratedPlanModel plan;

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 20,
          toolbarHeight: 100,
          title: Text(
            'preview',
            style: GoogleFonts.bebasNeue(
              fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.65),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 30,
                height: 30,
                child: IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.65),
                    foregroundColor: Theme.of(context).colorScheme.surface,
                  ),
                  icon: const Icon(
                    Icons.check_circle_sharp,
                    size: 28,
                  ),
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            //confirm on appbar
            // scrollable horiz list with days for which the plan is generated
            Flexible(
              flex: 4,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.plan.plan.length,
                itemBuilder: (ctx, ix) =>
                    PreviewTile(dayPlan: widget.plan.plan[ix]),
              ),
            ),
            //prompt to rerender plan gen
            Flexible(
              flex: 1,
              child: SuffixIconTextField(
                textField: TextField(
                  decoration: InputDecoration(
                    hintText: 'Describe the changes to be made',
                    hintStyle: GoogleFonts.bebasNeue(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                      fontSize:
                          Theme.of(context).textTheme.titleMedium!.fontSize,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 0.4,
                      ),
                    ),
                  ),
                  maxLines: 4,
                  style: GoogleFonts.raleway(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                  ),
                ),
                icon: Icon(
                  Icons.send_sharp,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.65),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
