import 'package:flutter/material.dart';

import '../services/home_services.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final HomeServices homeServices = HomeServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Example Network Manager"),
        ),
        body: FutureBuilder(
          future: homeServices.getHomeList(),
          builder: (context, snapshot) => homeServices.result.when(
            success: (data) {
              return ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  title: Text(data[index].title ?? ""),
                  subtitle: Text(data[index].body ?? ""),
                ),
                itemCount: data.length,
              );
            },
            failure: (error) {
              return Text(error.toString());
            },
          ),
        ));
  }
}
