import 'package:easy_stars/easy_stars.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';

class MovieInfoPage extends StatefulWidget {
  dynamic docs;
  MovieInfoPage({super.key, this.docs});

  @override
  State<MovieInfoPage> createState() => _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage> {
  late FlickManager flickManager;
  double _userRating = 0.0;
  bool _isExpanded = false;

  @override
  void initState() {
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(widget.docs['url']),
      ),
    );
    super.initState();

  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.docs['name'])),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FlickVideoPlayer(flickManager: flickManager),

            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            Title(
              color: Colors.white,
              child: Text(
                widget.docs['name'],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    const Color.fromRGBO(223, 213, 235, 100),
                  ),
                  foregroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(156, 27, 12, 34),
                  ),
                ),
                onPressed: () async {},
                child: Text("Смотреть"),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.bookmark, size: 20),
                    ),
                    Text(
                      "В избранное",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.visibility, size: 20),
                    ),
                    Text(
                      "Просмотрено",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                widget.docs['descriptiion'],
                maxLines: _isExpanded ? null : 5,
                overflow: _isExpanded ? null : TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Container(
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width * 0.8,
              child: InkWell(
                child: Text(
                  _isExpanded ? 'Свернуть' : 'Подробнее >',
                  style: TextStyle(color: Colors.deepPurple),
                ),
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.docs['stars'].toString(),
                    style: TextStyle(
                      fontSize: 55,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                  Column(
                    children: [
                      Text(
                        'Ваша оценка',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                      EasyStarsRating(
                        initialRating: double.parse(widget.docs['stars'].toString()),
                        filledColor: Colors.deepPurple,
                        emptyColor: Colors.white,
                        onRatingChanged: (rating) {
                          setState(() {
                            _userRating = rating;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
