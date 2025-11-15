import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:wonderlapse/models/custom_event_model.dart';
import 'package:wonderlapse/models/theme_model.dart';
import 'package:wonderlapse/services/custom_events_service.dart';

class CustomEventsScreen extends StatefulWidget {
  const CustomEventsScreen({super.key});

  @override
  State<CustomEventsScreen> createState() => _CustomEventsScreenState();
}

class _CustomEventsScreenState extends State<CustomEventsScreen> {
  final CustomEventsService _service = CustomEventsService();
  late Future<List<CustomEventModel>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _refreshEvents();
  }

  void _refreshEvents() {
    _eventsFuture = _service.loadEvents();
  }

  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) => _AddEventDialog(
        onAdd: (event) {
          _service.addEvent(event).then((_) {
            _refreshEvents();
            setState(() {});
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Events'),
        elevation: 0,
      ),
      body: FutureBuilder<List<CustomEventModel>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.event, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No custom events yet!'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addEvent,
                    child: const Text('Create Event'),
                  ),
                ],
              ),
            );
          }

          final events = snapshot.data!;
          final pinnedEvents = events.where((e) => e.isPinned).toList();
          final unpinnedEvents = events.where((e) => !e.isPinned).toList();

          return ListView(
            children: [
              if (pinnedEvents.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Pinned Events',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                ...pinnedEvents.map((event) => _buildEventCard(event)),
              ],
              if (unpinnedEvents.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Other Events',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                ...unpinnedEvents.map((event) => _buildEventCard(event)),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEventCard(CustomEventModel event) {
    final countdown = _service.getCountdown(event.targetDate);
    final isToday = _service.isEventToday(event.targetDate);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Text(
          event.icon,
          style: const TextStyle(fontSize: 32),
        ),
        title: Text(event.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isToday)
              const Text(
                'Today!',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              )
            else
              Text(
                '${countdown['days']} days, ${countdown['hours']} hours',
              ),
            Text(
              event.targetDate.toString().split(' ')[0],
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                event.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              ),
              onPressed: () {
                _service.togglePin(event.id).then((_) {
                  _refreshEvents();
                  setState(() {});
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _service.deleteEvent(event.id).then((_) {
                  _refreshEvents();
                  setState(() {});
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AddEventDialog extends StatefulWidget {
  final Function(CustomEventModel) onAdd;

  const _AddEventDialog({required this.onAdd});

  @override
  State<_AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<_AddEventDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _selectedDate;
  String _selectedIcon = '🎉';
  String _selectedTheme = 'classic';

  static const List<String> _icons = [
    '🎉',
    '🎂',
    '🎓',
    '💍',
    '🏠',
    '✈️',
    '🎄',
    '🎆',
    '🎊',
    '🎁',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Custom Event'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Event Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description (optional)'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Date: ${_selectedDate.toString().split(' ')[0]}',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (date != null) {
                      setState(() => _selectedDate = date);
                    }
                  },
                  child: const Text('Pick'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Icon: $_selectedIcon'),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _icons.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = _icons[index]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedIcon == _icons[index]
                                ? Colors.blue
                                : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(_icons[index], style: const TextStyle(fontSize: 24)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: _selectedTheme,
              isExpanded: true,
              items: AppThemeModel.themes
                  .map((theme) => DropdownMenuItem(
                        value: theme.id,
                        child: Text(theme.name),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedTheme = value ?? 'classic'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              final event = CustomEventModel(
                id: const Uuid().v4(),
                name: _nameController.text,
                targetDate: _selectedDate,
                icon: _selectedIcon,
                themeId: _selectedTheme,
                description: _descriptionController.text.isEmpty
                    ? null
                    : _descriptionController.text,
              );
              widget.onAdd(event);
              Navigator.pop(context);
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
