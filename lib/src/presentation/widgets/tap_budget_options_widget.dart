import 'package:app_gastos_grupo_61/core/helpers/app_theme.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/budget_with_balance.dart';
import 'package:app_gastos_grupo_61/src/presentation/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TapBudgetOptionsWidget extends StatefulWidget {
  final BudgetWithBalance budget; // Add budget parameter
  final VoidCallback onTapDelete; // Add a callback for the delete action

  const TapBudgetOptionsWidget({
    super.key,
    required this.budget, // Make budget required
    required this.onTapDelete, // Make onTapDelete required
  });

  @override
  State<TapBudgetOptionsWidget> createState() => _TapBudgetOptionsWidgetState();
}

class _TapBudgetOptionsWidgetState extends State<TapBudgetOptionsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 270.0,
      decoration: BoxDecoration(
        color: AppTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Color(0x3B1D2429),
            offset: Offset(0.0, -3.0),
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            FFButtonWidget(
              onPressed: () {
                Navigator.pop(context); // Dismiss the bottom sheet
                // Navigate to the update-budget route, passing the budget object
                GoRouter.of(context).pushNamed(
                  'update-budget', // TODO: Define this route
                  extra: widget.budget, // Use widget.budget
                );
              },
              text: 'Editar Presupuesto',
              options: FFButtonOptions(
                width: double.infinity,
                height: 60.0,
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: AppTheme.of(context).primaryBackground,
                textStyle: AppTheme.of(context).bodyLarge.override(
                  font: GoogleFonts.inter(
                    fontWeight: AppTheme.of(context).bodyLarge.fontWeight,
                    fontStyle: AppTheme.of(context).bodyLarge.fontStyle,
                  ),
                  color: AppTheme.of(context).primary,
                  letterSpacing: 0.0,
                  fontWeight: AppTheme.of(context).bodyLarge.fontWeight,
                  fontStyle: AppTheme.of(context).bodyLarge.fontStyle,
                ),
                elevation: 2.0,
                borderSide: BorderSide(color: Colors.transparent, width: 1.0),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () {
                  Navigator.pop(context); // Dismiss the bottom sheet
                  widget.onTapDelete(); // Call the onTapDelete callback
                },
                text: 'Eliminar Presupuesto',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 60.0,
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                  ),
                  color: AppTheme.of(context).primaryBackground,
                  textStyle: AppTheme.of(context).bodyLarge.override(
                    font: GoogleFonts.inter(
                      fontWeight: AppTheme.of(context).bodyLarge.fontWeight,
                      fontStyle: AppTheme.of(context).bodyLarge.fontStyle,
                    ),
                    color: AppTheme.of(context).primary,
                    letterSpacing: 0.0,
                    fontWeight: AppTheme.of(context).bodyLarge.fontWeight,
                    fontStyle: AppTheme.of(context).bodyLarge.fontStyle,
                  ),
                  elevation: 2.0,
                  borderSide: BorderSide(color: Colors.transparent, width: 1.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () async {
                  context.pop();
                },
                text: 'Cancelar',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 60.0,
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                  ),
                  color: AppTheme.of(context).primaryBackground,
                  textStyle: AppTheme.of(context).titleSmall.override(
                    font: GoogleFonts.lexendDeca(
                      fontWeight: FontWeight.normal,
                      fontStyle: AppTheme.of(context).titleSmall.fontStyle,
                    ),
                    color: AppTheme.of(context).primary,
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: AppTheme.of(context).titleSmall.fontStyle,
                  ),
                  elevation: 0.0,
                  borderSide: BorderSide(
                    color: AppTheme.of(context).primary,
                    width: 0.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
