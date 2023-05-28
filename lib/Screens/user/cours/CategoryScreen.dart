import 'package:flutter/material.dart';
import 'package:net4moly/Model/category.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/Screens/user/cours/cours_screen.dart';

class CategoryScreen extends StatelessWidget {
  List<Category> categories = [
    Category(name: 'Mathématiques', icon: Icons.calculate, id: 1),
    Category(name: 'Science', icon: Icons.science, id: 2),
    Category(name: 'Histoire', icon: Icons.history, id: 3),
    Category(name: 'Langue', icon: Icons.language, id: 4),
    Category(name: 'Technologie', icon: Icons.computer, id: 5),
    Category(name: 'Art', icon: Icons.palette, id: 6),
    Category(name: 'Musique', icon: Icons.music_note, id: 7),
    Category(name: 'Sport', icon: Icons.sports, id: 8),
    Category(name: 'Astronomie', icon: Icons.star, id: 9),
    Category(name: 'Géographie', icon: Icons.map, id: 10),
    Category(name: 'Économie', icon: Icons.monetization_on, id: 11),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CoursScreen(category: categories[index])));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: AppColors.mainColor1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Icon(
                        categories[index].icon,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${categories[index].name}',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                      SizedBox(height: 20)
                    ],
                  ),
                ),
              );
            }));
  }
}
