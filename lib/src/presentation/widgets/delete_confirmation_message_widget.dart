import 'package:app_gastos_grupo_61/core/helpers/app_theme.dart';
import 'package:app_gastos_grupo_61/src/presentation/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteConfirmationMessageWidget extends StatefulWidget {
  const DeleteConfirmationMessageWidget({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  State<DeleteConfirmationMessageWidget> createState() =>
      _DeleteConfirmationMessageWidgetState();
}

class _DeleteConfirmationMessageWidgetState
    extends State<DeleteConfirmationMessageWidget> {
  // late DeleteConfirmationMessageModel _model;

  // @override
  // void setState(VoidCallback callback) {
  //   super.setState(callback);
  //   _model.onUpdate();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _model = createModel(context, () => DeleteConfirmationMessageModel());
  // }

  // @override
  // void dispose() {
  //   _model.maybeDispose();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: 530.0),
          decoration: BoxDecoration(
            color: AppTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 3.0,
                color: Color(0x33000000),
                offset: Offset(0.0, 1.0),
              ),
            ],
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: AppTheme.of(context).primaryBackground,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    24.0,
                    16.0,
                    24.0,
                    16.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Eliminar registro',
                        textAlign: TextAlign.start,
                        style: AppTheme.of(context).headlineMedium.override(
                          font: GoogleFonts.interTight(
                            fontWeight:
                                AppTheme.of(context).headlineMedium.fontWeight,
                            fontStyle:
                                AppTheme.of(context).headlineMedium.fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight:
                              AppTheme.of(context).headlineMedium.fontWeight,
                          fontStyle:
                              AppTheme.of(context).headlineMedium.fontStyle,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          0.0,
                          12.0,
                          0.0,
                          0.0,
                        ),
                        child: Text(
                          'Esta acción eliminará el registro seleccionado de forma permanente. ¿Desea continuar?',
                          style: AppTheme.of(context).labelMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight:
                                  AppTheme.of(context).labelMedium.fontWeight,
                              fontStyle:
                                  AppTheme.of(context).labelMedium.fontStyle,
                            ),
                            color: AppTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                            fontWeight:
                                AppTheme.of(context).labelMedium.fontWeight,
                            fontStyle:
                                AppTheme.of(context).labelMedium.fontStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    24.0,
                    0.0,
                    24.0,
                    12.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          0.0,
                          0.0,
                          12.0,
                          0.0,
                        ),
                        child: FFButtonWidget(
                          onPressed: widget.onCancel,
                          text: 'Cancelar',
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                              20.0,
                              0.0,
                              20.0,
                              0.0,
                            ),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              0.0,
                              0.0,
                              0.0,
                            ),
                            color: AppTheme.of(context).secondaryBackground,
                            textStyle: AppTheme.of(context).bodyLarge.override(
                              font: GoogleFonts.inter(
                                fontWeight:
                                    AppTheme.of(context).bodyLarge.fontWeight,
                                fontStyle:
                                    AppTheme.of(context).bodyLarge.fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight:
                                  AppTheme.of(context).bodyLarge.fontWeight,
                              fontStyle:
                                  AppTheme.of(context).bodyLarge.fontStyle,
                            ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: AppTheme.of(context).primary,
                            ),
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: widget.onConfirm,
                        text: 'Eliminar',
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                            20.0,
                            0.0,
                            20.0,
                            0.0,
                          ),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                          ),
                          color: AppTheme.of(context).primary,
                          textStyle: AppTheme.of(context).titleSmall.override(
                            font: GoogleFonts.interTight(
                              fontWeight:
                                  AppTheme.of(context).titleSmall.fontWeight,
                              fontStyle:
                                  AppTheme.of(context).titleSmall.fontStyle,
                            ),
                            color: AppTheme.of(context).primaryBackground,
                            letterSpacing: 0.0,
                            fontWeight:
                                AppTheme.of(context).titleSmall.fontWeight,
                            fontStyle:
                                AppTheme.of(context).titleSmall.fontStyle,
                          ),
                          elevation: 0.0,
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                    ],
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
