import 'package:flutter/material.dart';

enum _DemoAction { reload, simulateError }

/// Meniu folosit la prezentare: reîncarcă datele (starea Loading)
/// sau citește un fișier inexistent (starea Error).
class DemoStatesMenu extends StatelessWidget {
  const DemoStatesMenu({
    super.key,
    required this.onReload,
    required this.onSimulateError,
    this.color,
  });

  final VoidCallback onReload;
  final VoidCallback onSimulateError;
  final Color? color;

  @override
  Widget build(BuildContext context) => PopupMenuButton<_DemoAction>(
    tooltip: 'Demo states',
    icon: Icon(Icons.more_vert_rounded, color: color),
    onSelected: (action) {
      switch (action) {
        case _DemoAction.reload:
          onReload();
        case _DemoAction.simulateError:
          onSimulateError();
      }
    },
    itemBuilder: (context) => const [
      PopupMenuItem(
        value: _DemoAction.reload,
        child: ListTile(
          leading: Icon(Icons.refresh_rounded),
          title: Text('Reload data'),
          subtitle: Text('Shows the Loading state'),
        ),
      ),
      PopupMenuItem(
        value: _DemoAction.simulateError,
        child: ListTile(
          leading: Icon(Icons.error_outline_rounded),
          title: Text('Simulate error'),
          subtitle: Text('Shows the Error state'),
        ),
      ),
    ],
  );
}
