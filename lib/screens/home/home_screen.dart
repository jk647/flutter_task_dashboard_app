// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../detail/detail_screen.dart';
import '../../providers/data_provider.dart';
import '../../models/item_model.dart';
import '../../extensions/size_ext.dart';
import '../../widgets/grid_card.dart';
import '../home/service/home_service.dart';
import '../../widgets/list_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            tooltip: _isGridView ? 'Switch to List View' : 'Switch to Grid View',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // provider is responsible for data; screen triggers refresh
              context.read<DataProvider>().refreshData();
            },
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Consumer<DataProvider>(
        builder: (context, provider, child) {
          // Loading state
          if (provider.state == DataState.loading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  16.h,
                  const Text('Loading data...'),
                ],
              ),
            );
          }

          // Error state
          if (provider.state == DataState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  16.h,
                  Text(
                    provider.errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  16.h,
                  ElevatedButton(
                    onPressed: () {
                      provider.refreshData();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Success state - Empty data
          if (provider.items.isEmpty) {
            return const Center(
              child: Text('No items available'),
            );
          }

          // Success state - Display data
          return RefreshIndicator(
            onRefresh: provider.refreshData,
            child: _isGridView
                ? _buildGridView(provider.items)
                : _buildListView(provider.items),
          );
        },
      ),
    );
  }

  Widget _buildGridView(List<Item> items) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossAxis = HomeService.computeCrossAxisCount(width);
      final padding = HomeService.computePadding(width);
      final aspect = HomeService.computeChildAspectRatio(width, crossAxis);

      return GridView.builder(
        padding: EdgeInsets.all(padding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxis,
          childAspectRatio: aspect,
          crossAxisSpacing: 12,
          mainAxisSpacing: 18,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GridCard(item: item, onTap: () => _navigateToDetail(item.id));
        },
      );
    });
  }

  Widget _buildListView(List<Item> items) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final padding = HomeService.computePadding(width);

      return ListView.builder(
        padding: EdgeInsets.all(padding),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListCard(item: item, onTap: () => _navigateToDetail(item.id));
        },
      );
    });
  }

  void _navigateToDetail(int itemId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(itemId: itemId),
      ),
    );
  }
}