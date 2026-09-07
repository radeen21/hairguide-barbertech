import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/core/dio_client.dart';
import 'package:hairguide_barberpedia/core/env/env_config.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/capster_detail_page.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/domain/capster_entity.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/presentation/capster_controller.dart';

class CapsterListPage extends StatefulWidget {
  final CapsterController controller;

  const CapsterListPage({super.key, required this.controller});

  @override
  State<CapsterListPage> createState() => _CapsterListPageState();
}

class _CapsterListPageState extends State<CapsterListPage> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, Uint8List> _imageCache = {};

  @override
  void initState() {
    super.initState();

    widget.controller.fetchCapsters();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        widget.controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<Uint8List> _loadImageWithAuth(String url) async {
  
    if (_imageCache.containsKey(url)) {
      return _imageCache[url]!;
    }

    final dio = DioClient.create();

    debugPrint("LOAD IMAGE = $url");

    final res = await dio.get(
      url,
      options: Options(responseType: ResponseType.bytes, followRedirects: true),
    );

    final bytes = Uint8List.fromList(res.data);

    _imageCache[url] = bytes;

    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Daftar Capster",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (_, __) {
  
          if (widget.controller.isLoading &&
              widget.controller.capsters.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.78,
            ),
            itemCount:
                widget.controller.capsters.length +
                (widget.controller.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
     
              if (index >= widget.controller.capsters.length) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                );
              }

              final capster = widget.controller.capsters[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CapsterDetailPage(capster: capster),
                    ),
                  );
                },
                child: _capsterCard(capster),
              );
            },
          );
        },
      ),
    );
  }

  Widget _capsterCard(CapsterEntity c) {
  final imageUrl = buildCapsterImageUrl(c.photoUrl);

  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[900],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: FutureBuilder<Uint8List>(
                  future: _loadImageWithAuth(imageUrl),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError || snapshot.data == null) {
                      debugPrint("IMAGE ERROR = ${snapshot.error}");
                      return Image.asset(
                        "assets/banner_grooming.png",
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    }

                    return Image.memory(
                      snapshot.data!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),

              /// RATING BADGE
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star,
                          color: Colors.orange, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        c.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                c.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

}

String buildCapsterImageUrl(String photoPath) {
  final clean = photoPath.trim();

  if (clean.isEmpty) return "";
  if (clean.startsWith("http")) return clean;

  final fixedPath = clean.startsWith("/") ? clean.substring(1) : clean;

  return "${EnvConfig.baseUrl}/photos/$fixedPath";
}
