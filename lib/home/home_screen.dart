// home/home_screen.dart
import 'dart:async';

import 'package:api/details/details_screen.dart';
import 'package:api/home/home_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// 'https://api.themoviedb.org/3/person/popular?api_key=2dfe23358236069710a379edd4c65a6b'
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Dio dio;
  @override
  void initState() {
    dio = Dio();
    getHomeData();
    super.initState();
  }

  HomeData? homeData;
  bool isLoading = true;
  Future getHomeData() async {
    try {
      final data = await dio.get(
        "https://api.themoviedb.org/3/person/popular?api_key=2dfe23358236069710a379edd4c65a6b",
      );

      final Map<String, dynamic> map = data.data;

      homeData = HomeData.fromJson(map);
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: isLoading
          ? Column(
              children: [
                SizedBox(height: 200, width: double.infinity),
                CircularProgressIndicator(color: Colors.blue),
              ],
            )
          : ListView.separated(
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailsScreen(id: homeData?.results[index].id ?? 0),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Image.network(
                        homeData?.results[index].profilePath ?? "",
                        width: 200,
                        height: 200,
                      ),
                      SizedBox(height: 12),
                      Text(homeData?.results[index].name ?? ""),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            homeData?.results[index].gender != 2
                                ? "female"
                                : "male",
                          ),
                          Text(
                            "Popularity : ${homeData?.results[index].popularity ?? ""}",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemCount: homeData?.results.length ?? 0,
            ),
    );
  }
}