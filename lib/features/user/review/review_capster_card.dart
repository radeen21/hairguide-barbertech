import 'package:flutter/material.dart';

class ReviewCapsterCard extends StatefulWidget {
  final String capsterId;
  final String capsterName;
  final String capsterPhotoUrl;
  final Future<void> Function({
    required String capsterId,
    required int rating,
    required String comment,
  }) onSubmit;

  const ReviewCapsterCard({
    super.key,
    required this.capsterId,
    required this.capsterName,
    required this.capsterPhotoUrl,
    required this.onSubmit,
  });

  @override
  State<ReviewCapsterCard> createState() => _ReviewCapsterCardState();
}

class _ReviewCapsterCardState extends State<ReviewCapsterCard> {
  int _rating = 0;
  bool _isLoading = false;

  bool get _isEnabled => _rating > 0 && !_isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          const Text(
            "Yuk kasih rating",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          /// CAPSTER INFO
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey.shade800,
                backgroundImage: widget.capsterPhotoUrl.isNotEmpty
                    ? NetworkImage(widget.capsterPhotoUrl)
                    : null,
                child: widget.capsterPhotoUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.capsterName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// STAR
                    Row(
                      children: List.generate(5, (index) {
                        final value = index + 1;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _rating = value);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Icon(
                              Icons.star,
                              size: 26,
                              color: _rating >= value
                                  ? Colors.amber
                                  : Colors.grey.shade700,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// SUBMIT
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isEnabled ? const Color(0xFFF6AD03) : Colors.grey.shade700,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isEnabled
                  ? () async {
                      setState(() => _isLoading = true);

                      try {
                        await widget.onSubmit(
                          capsterId: widget.capsterId,
                          rating: _rating,
                          comment: "Excellent service!",
                        );

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Review berhasil dikirim"),
                          ),
                        );
                      } catch (e) {
                        debugPrint("SUBMIT REVIEW ERROR: $e");
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Gagal mengirim review"),
                          ),
                        );
                      } finally {
                        if (mounted) setState(() => _isLoading = false);
                      }
                    }
                  : null,
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Text(
                      "Submit",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
