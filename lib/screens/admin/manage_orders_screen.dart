import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B0F2B),
      appBar: AppBar(
        title: Text(
          'Manage Orders',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF301848),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF301848),
                hintText: 'Search order by ID or customer name',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _buildStatusFilter('All'),
                _buildStatusFilter('Pending'),
                _buildStatusFilter('Completed'),
                _buildStatusFilter('Cancelled'),
                _buildStatusFilter('Refunded'),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildOrderCard('ORD1001', 'Imran Ashraf', 'May 18, 2025 - 2:20 PM', '\$24.99', 'Delivered'),
                _buildOrderCard('ORD1002', 'Muhammad Junaid', 'May 20, 2025 - 12:20 PM', '\$44.59', 'Processing'),
                _buildOrderCard('ORD1003', 'Abdul Rahman', 'May 21, 2025 - 10:30 AM', '\$54.39', 'Cancelled'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter(String status) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF301848),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Text(
          status,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildOrderCard(String orderId, String customerName, String date, String amount, String status) {
    Color statusColor;
    Color bgColor;

    switch (status.toLowerCase()) {
      case 'delivered':
        statusColor = Colors.greenAccent;
        bgColor = Colors.green.withOpacity(0.2);
        break;
      case 'processing':
        statusColor = Colors.orangeAccent;
        bgColor = Colors.orange.withOpacity(0.2);
        break;
      case 'cancelled':
        statusColor = Colors.redAccent;
        bgColor = Colors.red.withOpacity(0.2);
        break;
      default:
        statusColor = Colors.blueAccent;
        bgColor = Colors.blue.withOpacity(0.2);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF301848),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderId,
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              customerName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Text(
              amount,
              style: GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}