import 'package:flutter/material.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Layouts';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // AppBar substitute
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.menu),
                    Text(
                      'Layouts',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Icon(Icons.cloud_outlined),
                        SizedBox(width: 8),
                        Icon(Icons.more_vert),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Main image
              Image.asset(
                'images/gift.jpg',
                height: 200,
                fit: BoxFit.cover,
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Birthday",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "It’s going to be a great birthday. We are going out for dinner at my favorite place, "
                          "then watch a movie after we go to the gelateria for ice cream and espresso.",
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 12),
                        
                        // Weather & Location
                        Row(
                          children: [
                            Icon(Icons.wb_sunny, color: Colors.orange),
                            SizedBox(width: 6),
                            Text("81° Clear", style: TextStyle(color: Colors.orange)),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "4500 San Alpho Drive, Dallas, TX United States",
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Gift Buttons
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(7, (index) {
                            return ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.card_giftcard),
                              label: Text('Gift ${index + 1}'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                backgroundColor: Colors.blue[50],
                                foregroundColor: Colors.blue[800],
                              ),
                            );
                          }),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Food Images
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('images/food1.jpeg'),
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('images/food2.jpg'),
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('images/food3.jpeg'),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Bottom Icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.star_border),
                            SizedBox(width: 16),
                            Icon(Icons.music_note),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
