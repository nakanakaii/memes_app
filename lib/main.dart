import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart';
import 'memes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      darkTheme: ThemeData.dark(),
      home: const MemeApp(),
    );
  }
}

class MemeApp extends StatefulWidget {
  const MemeApp({Key? key}) : super(key: key);

  @override
  _MemeAppState createState() => _MemeAppState();
}

class _MemeAppState extends State<MemeApp> {
  Future<List<Memes>> fetchData() async {
    final response = await get(Uri.parse('https://api.imgflip.com/get_memes'));
    if (response.statusCode == 200) {
      // final Map<String, dynamic> jsonResponse =
      //     json.decode(response.body)['data']['memes'];
      // List<Memes> data = jsonResponse.map<Memes>((json) => Memes.fromJson(json)).toList();
      final List<dynamic> jsonResponse =
          json.decode(response.body)['data']['memes'];
      List<Memes> data =
          jsonResponse.map<Memes>((json) => Memes.fromJson(json)).toList();
      return data;
      // return jsonResponse.map((data) => Memes.fromJson(data)).toList();
    } else {
      throw Exception(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: FutureBuilder<List<Memes>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Memes>? data = snapshot.data;
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10.0)),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => const Center(
                                heightFactor: 3,
                                child: CircularProgressIndicator(),
                              ),
                              imageUrl: "${data![index].url}",
                            ),
                            // child: Image.network(
                            //   "${data![index].url}",
                            //   loadingBuilder: (BuildContext context,
                            //       Widget child,
                            //       ImageChunkEvent? loadingProgress) {
                            //     if (loadingProgress == null) return child;
                            //     return Center(
                            //       heightFactor: 3,
                            //       child: CircularProgressIndicator(
                            //         value: loadingProgress.expectedTotalBytes !=
                            //                 null
                            //             ? loadingProgress
                            //                     .cumulativeBytesLoaded /
                            //                 loadingProgress.expectedTotalBytes!
                            //             : null,
                            //       ),
                            //     );
                            //   },
                            // ),
                          ),
                          ListTile(
                            title: Text("${data[index].name}"),
                            subtitle: Text("${data[index].id}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: () {
                                GallerySaver.saveImage("${data[index].url}");
                                Fluttertoast.showToast(
                                    msg: "Saved to gallery",
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white);
                              },
                            ),
                          )
                        ],
                      ));
                });
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
