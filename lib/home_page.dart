// import 'package:flutter/material.dart';
// import 'models/vocabulary.dart';
// import 'models/topic.dart';
// import 'widgets/vocabulary_card.dart';
// import 'widgets/topic_card.dart';
// import 'screens/search_screen.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Sample data for today's vocabulary
//     final List<Vocabulary> todaysVocab = [
//       Vocabulary(
//         id: '1',
//         word: 'Dog',
//         meaning: 'A domesticated carnivorous mammal',
//         exampleSentence: 'The dog is playing outside.',
//         imageUrl: 'assets/images/dog.png',
//       ),
//       Vocabulary(
//         id: '2',
//         word: 'Family',
//         meaning: 'A flashcard of people related by blood or marriage',
//         exampleSentence: 'I spend time with my family every weekend.',
//         imageUrl: 'assets/images/family.png',
//       ),
//       Vocabulary(
//         id: '3',
//         word: 'Travel',
//         meaning:
//             'To go from one place to another, often for leisure or business',
//         exampleSentence: 'I love to travel to new countries.',
//         imageUrl: 'assets/images/travel.png',
//       ),
//     ];

//     // Sample data for topics
//     final List<Topic> topics = [
//       Topic(id: '1', name: 'Animals', imageUrl: 'assets/images/animals.png'),
//       Topic(id: '2', name: 'Health', imageUrl: 'assets/images/health.png'),
//       Topic(id: '3', name: 'Food', imageUrl: 'assets/images/food.png'),
//       Topic(id: '4', name: 'Nature', imageUrl: 'assets/images/nature.png'),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Flash Ability',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               // Navigate to search screen
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const SearchScreen()),
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               // TODO: Implement notifications functionality
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Notifications coming soon!')),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Today's Vocab",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 childAspectRatio: 0.8,
//               ),
//               itemCount: todaysVocab.length,
//               itemBuilder: (context, index) {
//                 return VocabularyCard(vocabulary: todaysVocab[index]);
//               },
//             ),
//             const SizedBox(height: 32),
//             const Text(
//               "Topics",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 childAspectRatio: 1.2,
//               ),
//               itemCount: topics.length,
//               itemBuilder: (context, index) {
//                 return TopicCard(topic: topics[index]);
//               },
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // TODO: Implement add new functionality
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: const Text('Add New'),
//                 content: const Text('Choose what you want to add:'),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Add Vocabulary'),
//                   ),
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Add Topic'),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
