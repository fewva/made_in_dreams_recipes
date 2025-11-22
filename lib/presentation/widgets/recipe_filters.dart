import 'package:flutter/material.dart';

class RecipeFilters extends StatefulWidget {
  final Function(bool?, int?) onFilterChanged;

  const RecipeFilters({super.key, required this.onFilterChanged});

  @override
  State<RecipeFilters> createState() => _RecipeFiltersState();
}

class _RecipeFiltersState extends State<RecipeFilters> {
  bool? _hasImage;
  int? _maxPrepTime;
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = _hasImage != null || _maxPrepTime != null;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  foregroundColor: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.filter_list),
                label: const Text('Фильтры'),
              ),
            ),
            if (hasActiveFilters)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _hasImage = null;
                      _maxPrepTime = null;
                    });
                    widget.onFilterChanged(null, null);
                  },
                  child: const Text('Очистить'),
                ),
              ),
          ],
        ),
        if (_showFilters)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Изображение',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  _buildFilterChip(
                    label: 'С изображением',
                    selected: _hasImage == true,
                    onSelected: (selected) {
                      setState(() {
                        _hasImage = selected ? true : null;
                      });
                      widget.onFilterChanged(_hasImage, _maxPrepTime);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Время приготовления',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: (_maxPrepTime ?? 0).toDouble(),
                          min: 0,
                          max: 300,
                          divisions: 30,
                          label: _maxPrepTime == null
                              ? 'Любое'
                              : '$_maxPrepTime минут',
                          onChanged: (value) {
                            setState(() {
                              _maxPrepTime = value.toInt() == 0
                                  ? null
                                  : value.toInt();
                            });
                            widget.onFilterChanged(_hasImage, _maxPrepTime);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 50,
                        child: Text(
                          _maxPrepTime == null
                              ? 'Любое'
                              : '$_maxPrepTime минут',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required Function(bool) onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      elevation: 0,
      pressElevation: 0,
      backgroundColor: Theme.of(
        context,
      ).colorScheme.surface.withValues(alpha: 0.6),
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: selected
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.onSurface,
      ),
      visualDensity: VisualDensity.comfortable,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
