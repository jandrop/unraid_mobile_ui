import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unmobile/global/drawer.dart';
import 'package:unmobile/global/queries.dart';
import 'package:unmobile/global/subscriptions.dart';
import 'package:unmobile/notifiers/auth_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unmobile/global/routes.dart';
import 'package:unmobile/notifiers/theme_mode.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _MyDashboardPageState createState() => _MyDashboardPageState();
}

class _MyDashboardPageState extends State<DashboardPage> {
  AuthState? _state;
  ThemeNotifier? _theme;
  Future<QueryResult>? _unreadNotifications;
  Future<QueryResult>? _serverCard;
  Future<QueryResult>? _arrayCard;
  Future<QueryResult>? _infoCard;
  Future<QueryResult>? _parityCard;
  Future<QueryResult>? _upsCard;
  Stream<QueryResult>? _cpuMetricsSubscription;

  bool _showMoreArrayDetails = false;

  @override
  void initState() {
    super.initState();
    _state = Provider.of<AuthState>(context, listen: false);
    _theme = Provider.of<ThemeNotifier>(context, listen: false);
    if (_state!.client != null) {
      _state!.client!.resetStore();
      getNotifications();
      getServerCard();
      getArrayCard();
      getInfoCard();
      getParityCard();
      getUpsCard();
      getMetricsSubscriptions();
    }
  }

  void getMetricsSubscriptions() {
    _cpuMetricsSubscription = _state!.client!.subscribe(SubscriptionOptions(
      document: gql(Subscriptions.getCpuMetrics),
    )).asBroadcastStream();
  }

  void getNotifications() {
    _unreadNotifications = _state!.client!.query(QueryOptions(
      document: gql(Queries.getNotificationsUnread),
    ));
  }

  void getServerCard() {
    _serverCard = _state!.client!.query(QueryOptions(
      document: gql(Queries.getServerCard),
    ));
  }

  void getArrayCard() {
    _arrayCard = _state!.client!.query(QueryOptions(
      document: gql(Queries.getArrayCard),
    ));
  }

  void getInfoCard() {
    _infoCard = _state!.client!.query(QueryOptions(
      document: gql(Queries.getInfoCard),
    ));
  }

  void getParityCard() {
    _parityCard = _state!.client!.query(QueryOptions(
      document: gql(Queries.getParityCard),
    ));
  }

  void getUpsCard() {
    _upsCard = _state!.client!.query(QueryOptions(
      document: gql(Queries.getUpsCard),
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'unConnect',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                _theme!.isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              ),
              tooltip: _theme!.isDarkMode ? 'Dark mode' : 'Light mode',
              onPressed: () {
                setState(() {
                  _theme!.toggleTheme();
                });
              },
            ),
            Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: showNotificationsButton())
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            if (_state!.client == null) {
              return;
            }
            _state!.client!.resetStore();
            getNotifications();
            getServerCard();
            getArrayCard();
            getInfoCard();
            getParityCard();
            getUpsCard();
            setState(() {});
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              showServerCard(),
              const SizedBox(height: 16),
              showArrayCard(),
              const SizedBox(height: 16),
              showInfoCard(),
              const SizedBox(height: 16),
              showParityCard(),
              const SizedBox(height: 16),
              showUpsCard(),
              const SizedBox(height: 16),
            ],
          ),
        ),
        drawer: MyDrawer());
  }

  void navigateNotifications() {
    Navigator.of(context).pushNamed(Routes.notifications);
  }

  Widget showServerCard() {
    return FutureBuilder<QueryResult>(
        future: _serverCard,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const SizedBox.shrink();
          } else if (snapshot.hasData && snapshot.data!.data != null) {
            final server = snapshot.data!.data!['server'];
            final vars = snapshot.data!.data!['vars'];
            final info = snapshot.data!.data!['info'];
            final colorScheme = Theme.of(context).colorScheme;

            return Card(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.server,
                                  color: colorScheme.onPrimaryContainer,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      server['name'],
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Version ${vars['version']}',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildStatusChip(server['status']),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Divider(color: colorScheme.outlineVariant),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            FontAwesomeIcons.clock,
                            'Uptime',
                            _formatUptime(info['os']['uptime']),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            FontAwesomeIcons.networkWired,
                            'LAN IP',
                            server['lanip'],
                          ),
                        ])));
          } else {
            return const SizedBox.shrink();
          }
        });
  }

  Widget _buildStatusChip(String status) {
    final colorScheme = Theme.of(context).colorScheme;
    final isOnline = status == 'ONLINE';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOnline 
          ? colorScheme.tertiaryContainer 
          : colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isOnline ? colorScheme.tertiary : colorScheme.error,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: isOnline 
                ? colorScheme.onTertiaryContainer 
                : colorScheme.onErrorContainer,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: FaIcon(
              icon,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget showArrayCard() {
    return FutureBuilder<QueryResult>(
        future: _arrayCard,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink();
          } else if (snapshot.hasData && snapshot.data!.data != null) {
            final array = snapshot.data!.data!['array'];
            final colorScheme = Theme.of(context).colorScheme;

            double size = array['capacity']['kilobytes']['total'] != null
                ? double.tryParse(array['capacity']['kilobytes']['total']
                            .toString()) !=
                        null
                    ? double.parse(array['capacity']['kilobytes']['total']
                            .toString()) /
                        1024 /
                        1024 /
                        1024
                    : 0
                : 0;
            double sizeTB = double.parse(size.toStringAsFixed(2));
            double used = array['capacity']['kilobytes']['used'] != null
                ? double.tryParse(array['capacity']['kilobytes']['used']
                            .toString()) !=
                        null
                    ? double.parse(
                            array['capacity']['kilobytes']['used'].toString()) /
                        1024 /
                        1024 /
                        1024
                    : 0
                : 0;
            double fillPercent = size > 0 ? (used / size) : 0;
            double sizeUsedTB = double.parse(used.toStringAsFixed(2));

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.hardDrive,
                            color: colorScheme.onSecondaryContainer,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Array',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildStatusChip(array['state']),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Storage',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStorageProgress(
                      fillPercent,
                      '$sizeUsedTB TB / $sizeTB TB',
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _showMoreArrayDetails = !_showMoreArrayDetails;
                        });
                      },
                      icon: Icon(
                        _showMoreArrayDetails
                            ? Icons.expand_less
                            : Icons.expand_more,
                      ),
                      label: Text(_showMoreArrayDetails ? 'Show less' : 'Show details'),
                    ),
                    if (_showMoreArrayDetails) ...[
                      const SizedBox(height: 16),
                      Divider(color: colorScheme.outlineVariant),
                      const SizedBox(height: 16),
                      Text(
                        'Disks',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(
                        array['disks'].length,
                        (index) {
                          final disk = array['disks'][index];
                          double total = disk['fsSize'] != null
                              ? double.tryParse(disk['fsSize'].toString()) ?? 0
                              : 0;
                          double used = disk['fsUsed'] != null
                              ? double.tryParse(disk['fsUsed'].toString()) ?? 0
                              : 0;
                          double percent = total > 0 ? (used / total) : 0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      disk['name'] ?? 'Unknown',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${(used / 1024 / 1024 / 1024).toStringAsFixed(1)} / ${(total / 1024 / 1024 / 1024).toStringAsFixed(1)} TB',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: percent,
                                    minHeight: 8,
                                    backgroundColor: colorScheme.surfaceContainerHighest,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _getProgressColor(percent),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      if (array['caches'].isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Caches',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(
                          array['caches'].length,
                          (index) {
                            final cache = array['caches'][index];
                            double total = cache['fsSize'] != null
                                ? double.tryParse(cache['fsSize'].toString()) ?? 0
                                : 0;
                            double used = cache['fsUsed'] != null
                                ? double.tryParse(cache['fsUsed'].toString()) ?? 0
                                : 0;
                            double percent = total > 0 ? (used / total) : 0;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        cache['name'] ?? 'Unknown',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '${(used / 1024 / 1024 / 1024).toStringAsFixed(1)} / ${(total / 1024 / 1024 / 1024).toStringAsFixed(1)} TB',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: percent,
                                      minHeight: 8,
                                      backgroundColor: colorScheme.surfaceContainerHighest,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _getProgressColor(percent),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }

  Widget _buildStorageProgress(double percent, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(percent * 100).toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getProgressColor(percent),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 12,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getProgressColor(percent),
            ),
          ),
        ),
      ],
    );
  }

  Color _getProgressColor(double percent) {
    final colorScheme = Theme.of(context).colorScheme;
    if (percent > 0.85) {
      return colorScheme.error;
    } else if (percent > 0.65) {
      return Colors.orange;
    } else {
      return colorScheme.tertiary;
    }
  }

  Widget showInfoCard() {
    return FutureBuilder<QueryResult>(
        future: _infoCard,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink();
          } else if (snapshot.hasData && snapshot.data!.data != null) {
            final info = snapshot.data!.data!['info'];
            final metrics = snapshot.data!.data!['metrics'];
            final colorScheme = Theme.of(context).colorScheme;

            double totalMem = double.tryParse(
                        metrics['memory']['total'].toString())
                    ?.roundToDouble() ??
                0;
            double totalGB =
                (totalMem / 1024 / 1024 / 1024).roundToDouble();
            double available = double.tryParse(
                        metrics['memory']['available'].toString())
                    ?.roundToDouble() ??
                0;
            double used = (totalMem - available).roundToDouble();
            double usedGB =
                (used / 1024 / 1024 / 1024).roundToDouble();
            double memPercent = totalMem > 0 ? used / totalMem : 0;

            return Card(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: colorScheme.tertiaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.microchip,
                                  color: colorScheme.onTertiaryContainer,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'System',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'CPU',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${info['cpu']['manufacturer']} ${info['cpu']['brand']}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${info['cpu']['cores']} Cores • ${info['cpu']['threads']} Threads',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 12),
                          StreamBuilder<QueryResult>(
                            stream: _cpuMetricsSubscription,
                            builder: (context, cpuSnapshot) {
                              double percent = 0;
                              if (cpuSnapshot.hasData &&
                                  cpuSnapshot.data!.data != null &&
                                  cpuSnapshot.data!.data!['systemMetricsCpu'] !=
                                      null) {
                                final cpuMetrics =
                                    cpuSnapshot.data!.data!['systemMetricsCpu'];
                                percent =
                                    double.tryParse(cpuMetrics['percentTotal'].toString()) ?? 0;
                              } else {
                                percent =
                                    double.tryParse(metrics['cpu']['percentTotal'].toString()) ?? 0;
                              }
                              return _buildStorageProgress(
                                percent / 100,
                                'CPU Load',
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Divider(color: colorScheme.outlineVariant),
                          const SizedBox(height: 20),
                          Text(
                            'Memory',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildStorageProgress(
                            memPercent,
                            '$usedGB GB / $totalGB GB',
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest.withAlpha(128),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.memory,
                                  size: 20,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '${info['baseboard']['manufacturer']} ${info['baseboard']['model']}',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ])));
          } else {
            return const SizedBox.shrink();
          }
        });
  }

  Widget showParityCard() {
    return FutureBuilder<QueryResult>(
        future: _parityCard,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink();
          } else if (snapshot.hasData && snapshot.data!.data != null) {
            final parityHistories = snapshot.data!.data!['parityHistory'];
            final parityHistory =
                parityHistories.isNotEmpty ? parityHistories[0] : null;
            if (parityHistory == null) {
              return const SizedBox.shrink();
            }
            final colorScheme = Theme.of(context).colorScheme;
            final isOk = parityHistory['status'] == 'OK' ||
                parityHistory['status'] == 'COMPLETED';
            
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isOk 
                              ? colorScheme.tertiaryContainer 
                              : colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.heartPulse,
                            color: isOk 
                              ? colorScheme.onTertiaryContainer 
                              : colorScheme.onErrorContainer,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Parity',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildStatusChip(parityHistory['status']),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Divider(color: colorScheme.outlineVariant),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      FontAwesomeIcons.calendar,
                      'Last check',
                      _formatDate(parityHistory?['date']),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      FontAwesomeIcons.clock,
                      'Duration',
                      _formatDuration(parityHistory?['duration']),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricChip(
                            FontAwesomeIcons.triangleExclamation,
                            'Errors',
                            parityHistory?['errors'].toString() ?? '0',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricChip(
                            FontAwesomeIcons.gaugeHigh,
                            'Speed',
                            '${((double.tryParse(parityHistory?['speed']?.toString() ?? '0') ?? 0) / 1024 / 1024).toStringAsFixed(1)} MB/s',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }

  Widget _buildMetricChip(IconData icon, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(128),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                icon,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget showUpsCard() {
    return FutureBuilder<QueryResult>(
        future: _upsCard,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink();
          } else if (snapshot.hasData && snapshot.data!.data != null) {
            final upsDevices = snapshot.data!.data!['upsDevices'];
            if (upsDevices.isEmpty) {
              return const SizedBox.shrink();
            }
            final colorScheme = Theme.of(context).colorScheme;
            
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.batteryThreeQuarters,
                            color: colorScheme.onPrimaryContainer,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'UPS Devices',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ...List.generate(upsDevices.length, (index) {
                      final device = upsDevices[index];
                      final battery = device['battery'];
                      final power = device['power'];
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index > 0) ...[
                            const SizedBox(height: 16),
                            Divider(color: colorScheme.outlineVariant),
                            const SizedBox(height: 16),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                device['name'] ?? device['model'] ?? 'Unknown Model',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _buildStatusChip(device['status'] ?? 'Unknown'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetricChip(
                                  FontAwesomeIcons.batteryFull,
                                  'Battery',
                                  '${battery?['chargeLevel'] ?? '-'}%',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildMetricChip(
                                  FontAwesomeIcons.heartPulse,
                                  'Health',
                                  battery?['health'] ?? '-',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest.withAlpha(128),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.arrowDown,
                                      size: 14,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'In',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${power?['inputVoltage'] ?? '-'} V',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: colorScheme.outlineVariant,
                                ),
                                Column(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.arrowUp,
                                      size: 14,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Out',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${power?['outputVoltage'] ?? '-'} V',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: colorScheme.outlineVariant,
                                ),
                                Column(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.gauge,
                                      size: 14,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Load',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${power?['loadPercentage'] ?? '-'}%',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }

  Widget showNotificationsButton() {
    return FutureBuilder<QueryResult>(
        future: _unreadNotifications,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => navigateNotifications());
          } else if (snapshot.hasData && snapshot.data!.data != null) {
            final result = snapshot.data!;
            int unreadTotalCount =
                result.data!['notifications']['overview']['unread']['total'];

            return IconButton(
                onPressed: () => navigateNotifications(),
                icon: Badge(
                  isLabelVisible: unreadTotalCount > 0,
                  label: Text(unreadTotalCount.toString()),
                  child: Icon(
                    unreadTotalCount > 0 
                      ? Icons.notifications_active 
                      : Icons.notifications_outlined,
                  ),
                ));
          } else {
            return IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => getNotifications());
          }
        });
  }

  String _formatUptime(String? isoTimestamp) {
    final dateTime = DateTime.tryParse(isoTimestamp ?? '');
    if (dateTime == null) {
      return 'Unknown';
    }
    final duration = DateTime.now().difference(dateTime);
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  String _formatDate(String? isoTimestamp) {
    final dateTime = DateTime.tryParse(isoTimestamp ?? '');
    if (dateTime == null) {
      return 'Unknown';
    }
    return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return 'Unknown';
    final duration = Duration(seconds: seconds);
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    }
  }

  Widget faIcon(IconData icon, {double? size}) {
    return FaIcon(
      icon,
      color: _theme!.isDarkMode ? Colors.orange : Colors.black,
      size: size,
    );
  }
}
