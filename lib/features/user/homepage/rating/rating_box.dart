import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/core/di/service_locator.dart';
import 'package:hairguide_barberpedia/features/user/review/presentation/review_controller.dart';

class ReviewRatingBox extends StatefulWidget {
  final String capsterId;
  final String capsterName;

  const ReviewRatingBox({
    super.key,
    required this.capsterId,
    required this.capsterName,
  });

  @override
  State<ReviewRatingBox> createState() => _ReviewRatingBoxState();
}

class _ReviewRatingBoxState extends State<ReviewRatingBox> {
  int selectedRating = 0;
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final reviewController = locator<ReviewController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Yuk kasih rating capster",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage("assets/banner_grooming.png"),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  widget.capsterName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Row(
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRating = starIndex;
                      });
                    },
                    child: Icon(
                      selectedRating >= starIndex
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.orange,
                      size: 24,
                    ),
                  );
                }),
              ),
            ],
          ),

          if (selectedRating > 0) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6AD03),
                  foregroundColor: Colors.black,
                ),
                onPressed: isSubmitting
                    ? null
                    : () async {
                        setState(() => isSubmitting = true);

                        final success = await reviewController.submit(
                          capsterId: widget.capsterId,
                          rating: selectedRating,
                          comment: "",
                        );

                        if (!mounted) return;

                        setState(() => isSubmitting = false);

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Review berhasil dikirim"),
                            ),
                          );
                        }
                      },
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("Kirim Review"),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
