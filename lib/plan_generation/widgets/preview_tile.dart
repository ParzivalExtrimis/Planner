import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planner/plan_generation/models/generated_plan_model.dart';

class PreviewTile extends StatefulWidget {
  const PreviewTile({super.key, required this.dayPlan});
  final Plan dayPlan;
  final Color cardColor = Colors.cyan;

  @override
  State<StatefulWidget> createState() => _PreviewTileState();
}

class _PreviewTileState extends State<PreviewTile> {
  Random random = Random();

  // final double outerBorder = 0.4;
  // final double innerBorder = 0.4;

  @override
  Widget build(BuildContext context) {
    final BorderSide outerBorder = BorderSide(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
      width: 1,
    );
    final BoxDecoration innerBorderDecoration = BoxDecoration(
      border: Border.all(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
        width: 0.8,
      ),
      borderRadius: BorderRadius.circular(12),
    );

    Size screenSize = MediaQuery.of(context).size;

    return SizedBox(
      //height: _screenSize.height * 0.6,
      width: screenSize.width * 0.85,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: outerBorder,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: innerBorderDecoration,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        'Day ${widget.dayPlan.day}',
                        style: GoogleFonts.bebasNeue(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          fontSize: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .fontSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ListView.builder(
                    itemCount: widget.dayPlan.tasks.length,
                    itemBuilder: (ctx, ix) {
                      debugPrint(widget.dayPlan.tasks[ix].toString());
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 8),
                        child: Container(
                          decoration: innerBorderDecoration,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 8,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Text(
                                      widget.dayPlan.tasks[ix].task!,
                                      maxLines: 4,
                                      style: GoogleFonts.raleway(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontWeight: FontWeight.w200,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .fontSize,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                //SizedBox(width: _screenSize.width * 0.1),
                                Flexible(
                                  flex: 3,
                                  child: CircleAvatar(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.65),
                                    radius: 33,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          widget.dayPlan.tasks[ix].startTime,
                                          style: GoogleFonts.bebasNeue(
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .fontSize,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          widget.dayPlan.tasks[ix].endTime,
                                          style: GoogleFonts.bebasNeue(
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .fontSize,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.7),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Text(
                    widget.dayPlan.summary ?? '',
                    style: GoogleFonts.raleway(
                      fontSize:
                          Theme.of(context).textTheme.titleMedium!.fontSize,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
