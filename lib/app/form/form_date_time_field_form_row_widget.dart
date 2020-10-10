import 'package:easy_localization/easy_localization.dart';
import 'package:fedi/app/ui/button/icon/fedi_icon_button.dart';
import 'package:fedi/app/ui/date_time/fedi_date_time_picker.dart';
import 'package:fedi/app/ui/fedi_colors.dart';
import 'package:fedi/app/ui/fedi_icons.dart';
import 'package:fedi/app/ui/fedi_text_styles.dart';
import 'package:fedi/app/ui/spacer/fedi_small_horizontal_spacer.dart';
import 'package:fedi/ui/form/field/value/date_time/form_date_time_field_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

var _logger = Logger("form_date_time_field_form_row_widget.dart");

class FormDateTimeFieldFormRowWidget extends StatelessWidget {
  final String label;
  final String desc;
  final IFormDateTimeFieldBloc field;
  final DateFormat dateFormat;

  final String popupTitle;

  static final DateFormat defaultDateFormat =
      DateFormat('MMMM dd, yyyy, HH:mm');

  FormDateTimeFieldFormRowWidget({
    @required this.label,
    @required this.popupTitle,
    this.desc,
    this.dateFormat,
    @required this.field,
  });

  @override
  Widget build(BuildContext context) {
    var format = dateFormat ?? defaultDateFormat;
    return StreamBuilder<DateTime>(
        stream: field.currentValueStream.distinct(),
        initialData: field.currentValue,
        builder: (context, snapshot) {
          var currentValue = snapshot.data;

          _logger.finest(() => "currentValue $currentValue");
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    label,
                    style: FediTextStyles.bigTallMediumGrey,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          showDatePicker(context);
                        },
                        child: Text(
                          format.format(field.currentValue),
                          style: FediTextStyles.bigTallMediumGrey,
                        ),
                      ),
                      const FediSmallHorizontalSpacer(),
                      FediIconButton(
                        icon: Icon(FediIcons.chevron_down),
                        color: FediColors.darkGrey,
                        onPressed: () {
                          showDatePicker(context);
                        },
                      )
                    ],
                  ),
                ],
              ),
              if (desc != null) Text(desc),
            ],
          );
        });
  }

  Future showDatePicker(BuildContext context) async {
    var minDateTime = field.minDateTime;
    var maxDateTime = field.maxDateTime;
    var dateTime = await FediDatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minDateTime: minDateTime,
      maxDateTime: maxDateTime,
      currentTime: field.currentValue,
      theme: FediDatePickerTheme.byDefault(customTitle: popupTitle),
      onCancel: () {},
      onConfirm: (date) {},
    );

    if (dateTime != null) {
      field.changeCurrentValue(dateTime);
    }
  }
}
