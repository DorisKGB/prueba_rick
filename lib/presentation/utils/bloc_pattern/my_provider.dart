import 'package:bpstate/bpstate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prueba_rick/presentation/utils/extension/extension_build_context.dart';
import 'dialog_key.dart';

class MyBlocProvider<T extends BlocBase> extends BlocProvider<T> {
  const MyBlocProvider({
    super.key,
    required super.child,
    required super.blocBuilder,
    required super.serviceLocator,
    super.blocDispose,
  });

  @override
  State<BlocProvider<T>> createState() => _MyBlocProviderState<T>();
}

class _MyBlocProviderState<T extends BlocBase> extends BlocProviderState<T> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    // Lógica personalizada para la inicialización del BLoC
    super.initState();
    bloc.dialogService.showProgess = _showProgress;
    bloc.dialogService.closeDialog = closeDialog;
    bloc.dialogService.registerDialogListener(
      DialogKey.error,
      _showMessageError,
    );
    bloc.dialogService.registerDialogListener(
      DialogKey.warning,
      _showMessageWarning,
    );
    bloc.dialogService.registerDialogListener(
      DialogKey.success,
      _showMessageSuccess,
    );
    bloc.dialogService.registerDialogListener(
      DialogKey.confirmation,
      _showMessageConfirmation,
    );
    bloc.toastService.registerComponent(component: _showToast);
  }

  @override
  void dispose() {
    // Lógica personalizada para la disposición del BLoC
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: super.build(context));
  }

  Future<void> _showProgress(String message) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            child: Padding(
              padding: EdgeInsets.fromLTRB(48.0, 72.0, 0, 72.0),
              child: Row(
                children: <Widget>[
                  const CircularProgressIndicator.adaptive(),
                  SizedBox(width: 48.0),
                  Expanded(
                    child: Text(
                      message,
                      style: context.body2.copyWith(
                        color: context.colors.primary,
                      ),
                      // const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void closeDialog() {
    if (mounted) {
      if (bloc.navigator.canPop()) {
        bloc.navigator.pop();
      }
    }
  }

  Future<void> _showMessageError(dynamic data) {
    if (!mounted) {
      return Future.value();
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: !kReleaseMode,
          child: Dialog(
            child: Padding(
              padding: EdgeInsets.all(48.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 32.0),
                  Text('Tenemos un problema'),
                  Padding(
                    padding: EdgeInsets.only(top: 48.0),
                    child: Text(data.toString()),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 48.0),
                    child: TextButton(
                      child: Text(
                        'Aceptar',
                        style: context.body2.copyWith(
                          color: context.colors.secondary,
                        ),
                      ),
                      onPressed: () {
                        bloc.dialogService.dialogComplete();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMessageWarning(dynamic data) {
    if (!mounted) {
      return Future.value();
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: !kReleaseMode,
          child: Dialog(
            child: Padding(
              padding: EdgeInsets.all(48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Atención',
                    style: context.headline1,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.all(48),
                    child: Text(data.toString(), textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 48),
                    child: TextButton(
                      child: Text(
                        'Aceptar',
                        style: context.body2.copyWith(
                          color: context.colors.secondary,
                        ),
                      ),
                      onPressed: () {
                        bloc.dialogService.dialogComplete();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMessageConfirmation(dynamic data) {
    if (!mounted) {
      return Future.value();
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: !kReleaseMode,
          child: Dialog(
            backgroundColor: context.colors.neutral,
            child: Padding(
              padding: EdgeInsets.all(48.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Confirmación',
                    style: context.headline1,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 48.0, bottom: 48.0),
                    child: Text(
                      style: context.body1.copyWith(
                        color: context.colors.primary,
                      ),
                      data.message.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              context.colors.neutral,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              context.colors.secondary,
                            ),
                            textStyle: WidgetStateProperty.all(
                              context.subtitle2,
                            ),
                          ),
                          onPressed: () {
                            bloc.dialogService.dialogComplete();
                            Navigator.pop(context);
                          },
                          child: Text(
                            'CANCELAR',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(width: 32.0),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              context.colors.secondary,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              context.colors.neutral,
                            ),
                            textStyle: WidgetStateProperty.all(
                              context.subtitle2,
                            ),
                          ),
                          onPressed: () {
                            data.action();
                            bloc.dialogService.dialogComplete();
                            Navigator.pop(context);
                          },
                          child: Text(
                            'CONFIRMAR',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMessageSuccess(dynamic data) {
    if (!mounted) {
      return Future.value();
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: !kReleaseMode,
          child: Dialog(
            child: Padding(
              padding: EdgeInsets.all(48.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Felicidades',
                    style: context.headline1,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 48.0, bottom: 48.0),
                    child: Text(data.toString(), textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: TextButton(
                      child: Text('Aceptar'),
                      onPressed: () {
                        bloc.dialogService.dialogComplete();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showToast(String message) {
    _overlayEntry?.remove(); // Remover el mensaje anterior si existe

    final OverlayState overlayState = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100.0,
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.white, width: 0.2),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8.0)],
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: context.body2.copyWith(color: context.colors.neutral),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(_overlayEntry!);

    // Eliminar el mensaje después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }
}
