import 'package:flutter/material.dart';

class FlashcardScreen extends StatefulWidget {
    const FlashcardScreen({super.key});

    @override
    State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  // final List<String> words = ['Father', 'Mother', 'Brother', 'Sister'];
  final List<String> imageUrls = [
    'https://fastly.picsum.photos/id/0/5000/3333.jpg?hmac=_j6ghY5fCfSD6tvtcV74zXivkJSPIfR9B8w34XeQmvU',
    'https://fastly.picsum.photos/id/1/5000/3333.jpg?hmac=Asv2DU3rA_5D1xSe22xZK47WEAN0wjWeFOhzd13ujW4',
    'https://fastly.picsum.photos/id/2/5000/3333.jpg?hmac=_KDkqQVttXw_nM-RyJfLImIbafFrqLsuGO5YuHqD-qQ',
    'https://fastly.picsum.photos/id/3/5000/3333.jpg?hmac=GDjZ2uNWE3V59PkdDaOzTOuV3tPWWxJSf4fNcxu4S2g'
  ];
  int currentIndex = 0;

  void moveToNextWord() {
    setState(() {
      currentIndex = (currentIndex + 1) % imageUrls.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String member = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(member), //Text(words[currentIndex]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_circle_left_outlined),
                  iconSize: 28,
                ),
                Expanded(
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          imageUrls[currentIndex],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: moveToNextWord,
                  icon: const Icon(Icons.arrow_circle_right_outlined),
                  iconSize: 28,
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}