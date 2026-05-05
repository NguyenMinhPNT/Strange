import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../cubit/stats_cubit.dart';
import '../cubit/stats_state.dart';
import '../widgets/column_chart_widget.dart';
import '../widgets/heatmap_calendar.dart';
import '../widgets/heatmap_legend.dart';
import '../widgets/pie_chart_widget.dart';
import '../widgets/stats_range_selector.dart';
import '../widgets/stats_section_header.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StatsCubit>()..loadStats(),
      child: const _StatsView(),
    );
  }
}

class _StatsView extends StatelessWidget {
  const _StatsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: AppColors.surfaceBase,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<StatsCubit, StatsState>(
        builder: (context, state) {
          return switch (state) {
            StatsInitial() => const _LoadingBody(),
            StatsLoading() => const _LoadingBody(),
            StatsError(:final message) => _ErrorBody(message: message),
            StatsLoaded() => _LoadedBody(state: state),
          };
        },
      ),
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
          const SizedBox(height: 12),
          const Text(
            'Failed to load stats',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style:
                const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<StatsCubit>().loadStats(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.state});

  final StatsLoaded state;

  @override
  Widget build(BuildContext context) {
    final totalHours = state.totalWorkSeconds / 3600;
    final totalLabel = totalHours >= 1
        ? '${totalHours.toStringAsFixed(1)}h'
        : '${state.totalWorkSeconds ~/ 60}m';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Range selector
          const StatsRangeSelector(),
          const SizedBox(height: 24),

          // Summary chip
          _SummaryChip(label: 'Total focus time: $totalLabel'),
          const SizedBox(height: 28),

          // Heatmap
          const StatsSectionHeader(title: 'Activity'),
          HeatmapCalendar(data: state.heatmap, range: state.range),
          const SizedBox(height: 6),
          const HeatmapLegend(),
          const SizedBox(height: 28),

          // Column chart
          const StatsSectionHeader(title: 'Daily Breakdown'),
          _ClayCard(child: ColumnChartWidget(data: state.columns)),
          const SizedBox(height: 28),

          // Pie chart
          const StatsSectionHeader(title: 'By Category'),
          _ClayCard(
            child: PieChartWidget(
              slices: state.pieSlices,
              totalSeconds: state.totalWorkSeconds,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _ClayCard extends StatelessWidget {
  const _ClayCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.clayShadowNeutral,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.clayHighlight,
            blurRadius: 0,
            spreadRadius: -1,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: child,
    );
  }
}
