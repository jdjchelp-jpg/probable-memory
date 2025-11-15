import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:wonderlapse/models/gift_model.dart';
import 'package:wonderlapse/services/gift_planner_service.dart';

class GiftPlannerWidget extends StatefulWidget {
  const GiftPlannerWidget({super.key});

  @override
  State<GiftPlannerWidget> createState() => _GiftPlannerWidgetState();
}

class _GiftPlannerWidgetState extends State<GiftPlannerWidget> {
  final GiftPlannerService _service = GiftPlannerService();
  late Future<List<GiftModel>> _giftsFuture;
  late Future<GiftStats> _statsFuture;

  @override
  void initState() {
    super.initState();
    _refreshGifts();
  }

  void _refreshGifts() {
    _giftsFuture = _service.loadGifts();
    _statsFuture = _service.getStats();
  }

  void _addGift() {
    showDialog(
      context: context,
      builder: (context) => _AddGiftDialog(
        onAdd: (gift) {
          _service.addGift(gift).then((_) {
            _refreshGifts();
            setState(() {});
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<GiftStats>(
          future: _statsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }

            final stats = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Gift Planner',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard('Total', '${stats.total}'),
                      _buildStatCard('Purchased', '${stats.purchased}'),
                      _buildStatCard('Wrapped', '${stats.wrapped}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (stats.total > 0) ...[
                    _buildProgressBar(
                      'Purchase Progress',
                      stats.purchasePercentage,
                      Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildProgressBar(
                      'Wrapping Progress',
                      stats.wrappedPercentage,
                      Colors.green,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Total Budget: \$${stats.totalCost.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
        Expanded(
          child: FutureBuilder<List<GiftModel>>(
            future: _giftsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.card_giftcard, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('No gifts yet!'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _addGift,
                        child: const Text('Add Gift'),
                      ),
                    ],
                  ),
                );
              }

              final gifts = snapshot.data!;
              return ListView.builder(
                itemCount: gifts.length,
                itemBuilder: (context, index) {
                  final gift = gifts[index];
                  return _buildGiftCard(gift);
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _addGift,
            icon: const Icon(Icons.add),
            label: const Text('Add Gift'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 8,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildGiftCard(GiftModel gift) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Checkbox(
          value: gift.isPurchased,
          onChanged: (value) {
            _service.togglePurchased(gift.id).then((_) {
              _refreshGifts();
              setState(() {});
            });
          },
        ),
        title: Text(gift.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (gift.recipient != null) Text('For: ${gift.recipient}'),
            if (gift.estimatedCost != null)
              Text('\$${gift.estimatedCost!.toStringAsFixed(2)}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                gift.isWrapped ? Icons.card_giftcard : Icons.card_giftcard_outlined,
              ),
              onPressed: () {
                _service.toggleWrapped(gift.id).then((_) {
                  _refreshGifts();
                  setState(() {});
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _service.deleteGift(gift.id).then((_) {
                  _refreshGifts();
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

class _AddGiftDialog extends StatefulWidget {
  final Function(GiftModel) onAdd;

  const _AddGiftDialog({required this.onAdd});

  @override
  State<_AddGiftDialog> createState() => _AddGiftDialogState();
}

class _AddGiftDialogState extends State<_AddGiftDialog> {
  final _nameController = TextEditingController();
  final _recipientController = TextEditingController();
  final _costController = TextEditingController();
  String _category = 'General';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Gift'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Gift Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _recipientController,
              decoration: const InputDecoration(labelText: 'Recipient'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _costController,
              decoration: const InputDecoration(labelText: 'Estimated Cost'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: _category,
              isExpanded: true,
              items: ['General', 'Electronics', 'Clothing', 'Books', 'Toys', 'Other']
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) => setState(() => _category = value ?? 'General'),
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
              final gift = GiftModel(
                id: const Uuid().v4(),
                name: _nameController.text,
                recipient: _recipientController.text.isEmpty
                    ? null
                    : _recipientController.text,
                category: _category,
                estimatedCost: double.tryParse(_costController.text),
              );
              widget.onAdd(gift);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _recipientController.dispose();
    _costController.dispose();
    super.dispose();
  }
}
