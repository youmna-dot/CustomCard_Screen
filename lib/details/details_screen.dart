// details/details_screen.dart
import 'dart:async';

import 'package:api/details/details_model.dart';
import 'package:api/details/photos_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final int id;
  const DetailsScreen({super.key, required this.id});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late final Dio dio;
  @override
  void initState() {
    dio = Dio();
    getDetails();
    getPhotos();
    super.initState();
  }

  bool loading = true;
  bool photosLoading = true;
  DetailsData? data;
  PhotosData? photos;
  Future<void> getDetails() async {
    try {
      final Response response = await dio.get(
        "https://api.themoviedb.org/3/person/${widget.id}?api_key=2dfe23358236069710a379edd4c65a6b",
      );
      data = DetailsData.fromJson(response.data);
    } catch (e) {
      print(e);
    } finally {
      loading = false;
      setState(() {});
    }
  }

  Future<void> getPhotos() async {
    try {
      final Response response = await dio.get(
        "https://api.themoviedb.org/3/person/${widget.id}/images?api_key=2dfe23358236069710a379edd4c65a6b",
      );
      photos = PhotosData.fromJson(response.data);
    } catch (e) {
      print(e);
    } finally {
      photosLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.photo))],
        title: const Text(
          'Details Screen',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Image.network(
                  data?.profilePath ?? "",
                  height: MediaQuery.of(context).size.height / 2.5,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data?.name ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(data?.birthday.toString() ?? ""),
                      const SizedBox(height: 4),
                      Text("mansoura"),
                      const SizedBox(height: 4),
                      Text(
                        data?.biography ?? "",
                        maxLines: 7,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (photosLoading)
                        Center(child: CircularProgressIndicator())
                      else
                        SizedBox(
                          height: 300,
                          child: GridView.builder(
                            // physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 130,
                                  childAspectRatio: 100 / 100,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                            itemCount: photos?.profiles.length ?? 0,
                            itemBuilder: (context, index) => Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: const Color(0xffD5D5DE),
                                  width: 2.4,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    photos?.profiles[index].filePath ?? "",
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}