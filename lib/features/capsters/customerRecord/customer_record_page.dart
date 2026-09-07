import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/presentation/capster_history_controller.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/capster_history_item.dart';

class CustomerRecordPage extends StatefulWidget {
  final CapsterHistoryController controller;

  const CustomerRecordPage({super.key, required this.controller});

  @override
  State<CustomerRecordPage> createState() => _CustomerRecordPageState();
}

class _CustomerRecordPageState extends State<CustomerRecordPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16, 
        title: const Text(
          "CUSTOMER RECORD",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.search, color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.filter_alt_outlined, color: Colors.white),
          ),
        ],
      ),

      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (_, __) {
          if (widget.controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          if (widget.controller.histories.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada data",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: widget.controller.histories.length,
            itemBuilder: (_, index) {
              final item = widget.controller.histories[index];
              return CapsterHistoryItem(data: item);
            },
          );
        },
      ),
    );
  }
}
