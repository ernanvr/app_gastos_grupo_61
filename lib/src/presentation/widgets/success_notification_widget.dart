import 'package:app_gastos_grupo_61/core/helpers/app_theme.dart';
import 'package:app_gastos_grupo_61/core/utils/list_divide_extension.dart';
import 'package:app_gastos_grupo_61/src/presentation/widgets/icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessNotificationWidget extends StatefulWidget {
  const SuccessNotificationWidget({super.key});

  @override
  State<SuccessNotificationWidget> createState() =>
      _SuccessNotificationWidgetState();
}

class _SuccessNotificationWidgetState extends State<SuccessNotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.0,
      decoration: BoxDecoration(
        color: AppTheme.of(context).success,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          ),
        ],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppTheme.of(context).accent4),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.add_task_rounded,
                          color: AppTheme.of(context).info,
                          size: 24.0,
                        ),
                      ),
                      Text(
                        'Registro actualizado',
                        style: AppTheme.of(context).titleSmall.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.bold,
                            fontStyle:
                                AppTheme.of(context).titleSmall.fontStyle,
                          ),
                          color: AppTheme.of(context).primaryBackground,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: AppTheme.of(context).titleSmall.fontStyle,
                        ),
                      ),
                    ].divide(SizedBox(width: 8.0)),
                  ),
                  Text(
                    'La transacción se ha registrado satisfactoriamente.',
                    textAlign: TextAlign.start,
                    style: AppTheme.of(context).labelMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: AppTheme.of(context).labelMedium.fontWeight,
                        fontStyle: AppTheme.of(context).labelMedium.fontStyle,
                      ),
                      color: AppTheme.of(context).primaryBackground,
                      letterSpacing: 0.0,
                      fontWeight: AppTheme.of(context).labelMedium.fontWeight,
                      fontStyle: AppTheme.of(context).labelMedium.fontStyle,
                    ),
                  ),
                ].divide(SizedBox(height: 4.0)),
              ),
            ),
            AppIconButton(
              borderColor: Colors.transparent,
              borderRadius: 20.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              hoverColor: AppTheme.of(context).primaryBackground,
              icon: Icon(
                Icons.close_rounded,
                color: AppTheme.of(context).info,
                size: 24.0,
              ),
              onPressed: () {
                print('IconButton pressed ...');
              },
            ),
          ].divide(SizedBox(width: 8.0)),
        ),
      ),
    );
  }
}
