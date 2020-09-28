import 'package:easy_localization/easy_localization.dart';
import 'package:fedi/app/form/form_string_field_form_row_widget.dart';
import 'package:fedi/app/timeline/create/create_timeline_bloc.dart';
import 'package:fedi/app/timeline/form/timeline_type_form_field_row_widget.dart';
import 'package:fedi/app/timeline/settings/timeline_settings_form_bloc.dart';
import 'package:fedi/app/timeline/settings/timeline_settings_widget.dart';
import 'package:fedi/app/timeline/timeline_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CreateItemTimelinesHomeTabStorageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var createTimelineBloc = ICreateTimelineBloc.of(context, listen: false);

    var timelineTypeFieldBloc = createTimelineBloc.typeFieldBloc;

    return Column(
      children: [
        FormStringFieldFormRowWidget(
          enabled: false,
          label: "app.timeline.create.field.id.label".tr(),
          autocorrect: true,
          textInputAction: TextInputAction.done,
          onSubmitted: null,
          formStringFieldBloc: createTimelineBloc.idFieldBloc,
          hint: null,
        ),
        FormStringFieldFormRowWidget(
          label: "app.timeline.create.field.title.label".tr(),
          autocorrect: true,
          hint: "app.timeline.create.field.title.hint".tr(),
          textInputAction: TextInputAction.done,
          onSubmitted: null,
          formStringFieldBloc: createTimelineBloc.nameFieldBloc,
        ),
        TimelineTypeFormFieldRowWidget(
          formValueFieldBloc: timelineTypeFieldBloc,
          desc: null,
        ),
        Expanded(
          child: Provider<ITimelineSettingsFormBloc>.value(
            value: createTimelineBloc.settingsFormBloc,
            child: StreamBuilder<TimelineType>(
                initialData: createTimelineBloc.typeFieldBloc.currentValue,
                stream: createTimelineBloc.typeFieldBloc.currentValueStream,
                builder: (context, snapshot) {
                  var currentValue = snapshot.data;
                  return TimelineSettingsWidget(
                    type: currentValue,
                    isNullablePossible: true,
                  );
                }),
          ),
        )
      ],
    );
  }
}