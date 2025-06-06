import 'package:flutter/material.dart';
import 'package:testing/widgets/double_back_to_exit.dart';
import 'package:testing/layouts/main.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final dummyFeeds = [
    {
      "name": "Fredy Siswanto",
      "position": "QA Engineer | API Testing | SDET | Tester",
      "time": "2w",
      "text":
      "Beberapa waktu yang lalu saya sempat share repo yang bisa digunakan untuk testing API local...",
      "image":
      "https://pbs.twimg.com/media/GoHkIl5bEAAtrVX?format=jpg&name=medium"
    },
    {
      "name": "Eric Partaker",
      "position": "CEO Coach | McKinsey Award Winner",
      "time": "2d",
      "text":
      "8 rare traits of a leader with emotional intelligence. It's not IQ or tech skills...",
      "image":
      "https://pbs.twimg.com/media/GoHkIl5bEAAtrVX?format=jpg&name=medium"
    },
    {
      "name": "Eric Partaker",
      "position": "CEO Coach | McKinsey Award Winner",
      "time": "2d",
      "text":
      "8 rare traits of a leader with emotional intelligence. It's not IQ or tech skills...",
      "image":
      "https://pbs.twimg.com/media/GoHkIl5bEAAtrVX?format=jpg&name=medium"
    },
    {
      "name": "Eric Partaker",
      "position": "CEO Coach | McKinsey Award Winner",
      "time": "2d",
      "text":
      "8 rare traits of a leader with emotional intelligence. It's not IQ or tech skills...",
      "image":
      "https://pbs.twimg.com/media/GoHkIl5bEAAtrVX?format=jpg&name=medium"
    },
    {
      "name": "Eric Partaker",
      "position": "CEO Coach | McKinsey Award Winner",
      "time": "2d",
      "text":
      "8 rare traits of a leader with emotional intelligence. It's not IQ or tech skills...",
      "image":
      "https://pbs.twimg.com/media/GoHkIl5bEAAtrVX?format=jpg&name=medium"
    },
    {
      "name": "Eric Partaker",
      "position": "CEO Coach | McKinsey Award Winner",
      "time": "2d",
      "text":
      "8 rare traits of a leader with emotional intelligence. It's not IQ or tech skills...",
      "image":
      "https://pbs.twimg.com/media/GoHkIl5bEAAtrVX?format=jpg&name=medium"
    },
    {
      "name": "Eric Partaker",
      "position": "CEO Coach | McKinsey Award Winner",
      "time": "2d",
      "text":
      "8 rare traits of a leader with emotional intelligence. It's not IQ or tech skills...",
      "image":
      "https://pbs.twimg.com/media/GoHkIl5bEAAtrVX?format=jpg&name=medium"
    }
  ];

  @override
  Widget build(BuildContext context) {

    return DoubleBackToExitWrapper(
      child: MainLayout(
        title: 'Berita Terkini',
        titleIcon: Icon(Icons.newspaper),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: dummyFeeds.length,
          itemBuilder: (context, index) {
            final feed = dummyFeeds[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            'https://pbs.twimg.com/profile_images/1513741421937045504/8fEVPrh7_x96.jpg',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(feed['name'] ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(feed['position'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Text(feed['time'] ?? '',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(feed['text'] ?? ''),
                    const SizedBox(height: 12),
                    if (feed['image'] != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(feed['image']!, fit: BoxFit.cover),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Icon(Icons.thumb_up_alt_outlined, size: 20),
                        Icon(Icons.comment_outlined, size: 20),
                        Icon(Icons.repeat, size: 20),
                        Icon(Icons.send_outlined, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
