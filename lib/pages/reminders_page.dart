import 'package:flutter/material.dart';
import '../Services/notification_service.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recordatorios')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ElevatedButton(
            onPressed: () => NotificationService.instance.scheduleDaily(
              1,
              hour: 7,
              minute: 30,
              title: 'Café',
              body: 'Prepara el espresso',
            ),
            child: const Text('Programar 07:30'),
          ),
          ElevatedButton(
            onPressed: () => NotificationService.instance.scheduleMultipleDaily([(9,0),(14,0),(20,30)]),
            child: const Text('Programar 9:00, 14:00, 20:30'),
          ),
          ElevatedButton(
            onPressed: () => NotificationService.instance.cancelAll(),
            child: const Text('Cancelar todas'),
          ),
        ]),
      ),
    );
  }
}