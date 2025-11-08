import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});
  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 30);
  int _nextId = 0;

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _time);
    if (t != null) setState(() => _time = t);
  }

  Future<void> _scheduleOne() async {
    await NotificationService.instance.scheduleDaily(
      _nextId,
      hour: _time.hour,
      minute: _time.minute,
      title: 'CoffeeMaster',
      body: 'Hora de preparar café',
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Programada $_nextId a ${_time.format(context)}')),
    );
    setState(() => _nextId++);
  }

  Future<void> _scheduleExample3() async {
    await NotificationService.instance.scheduleMultipleDaily(const [
      (9, 0),
      (14, 0),
      (20, 30),
    ], title: 'CoffeeMaster');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Programadas 3 notificaciones diarias')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recordatorios')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('Hora diaria'),
              subtitle: Text(_time.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: _pickTime,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _scheduleOne,
              child: const Text('Programar notificación diaria'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _scheduleExample3,
              child: const Text('Programar 9:00, 14:00, 20:30'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: NotificationService.instance.cancelAll,
              child: const Text('Cancelar todas'),
            ),
          ],
        ),
      ),
    );
  }
}
