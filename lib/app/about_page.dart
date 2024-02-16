//Programmer Name: Naimur Rahman Shahed, student of Computer Science (CS), APU, Malaysia
//TP060805

import 'package:flutter/material.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({Key? key}) : super(key: key);

//about page which shows what this app has to offer

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn more about Restora'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Restora!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Restora is designed to help you find the best restaurants and foods. Our app also offers a unique feature where we provide random restaurant recommendations to our users. With just a click of a button, our app suggests a restaurant that you might enjoy. This is a great way to discover new dining experiences and try out different cuisines. Give it a try and let us surprise you with our recommendations!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 0.5,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Features:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FeatureItem(
                      title: 'Search for restaurants by location or food',
                      icon: Icons.search,
                    ),
                    SizedBox(height: 10),
                    FeatureItem(
                      title: 'Save your favorite restaurants',
                      icon: Icons.favorite,
                    ),
                    SizedBox(height: 10),
                    FeatureItem(
                      title:
                          'Write reviews and share your experiences with other foodies',
                      icon: Icons.rate_review,
                    ),
                    SizedBox(height: 10),
                    FeatureItem(
                      title: 'Add new restaurants',
                      icon: Icons.add,
                    ),
                    SizedBox(height: 10),
                    FeatureItem(
                      title: 'Get random restaurant recommendations',
                      icon: Icons.shuffle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const FeatureItem({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 32,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              letterSpacing: 0.5,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }
}
