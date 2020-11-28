import 'package:fedi/app/ui/form/fedi_form_column_desc.dart';
import 'package:fedi/app/ui/form/fedi_form_row.dart';
import 'package:fedi/app/ui/form/fedi_form_row_label.dart';
import 'package:fedi/form/field/form_field_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FediFormFieldRow extends StatelessWidget {
  final Widget label;
  final Widget description;
  final Widget descriptionOnDisabled;
  final Widget valueChild;

  FediFormFieldRow({
    @required this.label,
    @required this.description,
    @required this.descriptionOnDisabled,
    @required this.valueChild,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FediFormRow(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                label,
                valueChild,
              ],
            ),
          ),
          _FediFormFieldRowDescriptionWidget(
            description: description,
            descriptionOnDisabled: descriptionOnDisabled,
          ),
        ],
      );
}

class _FediFormFieldRowDescriptionWidget extends StatelessWidget {
  const _FediFormFieldRowDescriptionWidget({
    Key key,
    @required this.description,
    @required this.descriptionOnDisabled,
  }) : super(key: key);
  final Widget description;
  final Widget descriptionOnDisabled;

  @override
  Widget build(BuildContext context) {
    var formFieldBloc = IFormFieldBloc.of(context);
    return StreamBuilder<bool>(
      stream: formFieldBloc.isEnabledStream,
      initialData: formFieldBloc.isEnabled,
      builder: (context, snapshot) {
        var isEnabled = snapshot.data;

        if (isEnabled) {
          if (description != null) {
            return description;
          } else {
            return const SizedBox.shrink();
          }
        } else {
          if (descriptionOnDisabled != null) {
            return descriptionOnDisabled;
          } else {
            if (description != null) {
              return description;
            } else {
              return const SizedBox.shrink();
            }
          }
        }
      },
    );
  }
}

class SimpleFediFormFieldRow extends StatelessWidget {
  final String label;
  final String description;
  final String descriptionOnDisabled;
  final Widget valueChild;

  SimpleFediFormFieldRow({
    @required this.label,
    @required this.description,
    @required this.descriptionOnDisabled,
    @required this.valueChild,
  });

  @override
  Widget build(BuildContext context) => FediFormFieldRow(
        label: FediFormRowLabel(label),
        description: description?.isNotEmpty == true
            ? FediFormColumnDesc(description)
            : null,
        descriptionOnDisabled: descriptionOnDisabled?.isNotEmpty == true
            ? FediFormColumnDesc(descriptionOnDisabled)
            : null,
        valueChild: valueChild,
      );
}