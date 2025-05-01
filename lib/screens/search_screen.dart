import 'package:flutter/material.dart';
import 'dart:async';
import '../models/vocabulary.dart';
import '../models/topic.dart';
import '../widgets/vocabulary_card.dart';
import '../widgets/topic_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String _searchQuery = '';

  List<Vocabulary> _allVocabulary = [];
  List<Topic> _allTopics = [];

  List<Vocabulary> _filteredVocabulary = [];
  List<Topic> _filteredTopics = [];

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize with sample data
    _loadSampleData();
  }

  void _loadSampleData() {
    // Sample vocabulary data
    _allVocabulary = [
      Vocabulary(
        id: '1',
        word: 'Dog',
        meaning: 'A domesticated carnivorous mammal',
        exampleSentence: 'The dog is playing outside.',
        imageUrl: 'assets/images/dog.png',
      ),
      Vocabulary(
        id: '2',
        word: 'Family',
        meaning: 'A group of people related by blood or marriage',
        exampleSentence: 'I spend time with my family every weekend.',
        imageUrl: 'assets/images/family.png',
      ),
      Vocabulary(
        id: '3',
        word: 'Travel',
        meaning:
            'To go from one place to another, often for leisure or business',
        exampleSentence: 'I love to travel to new countries.',
        imageUrl: 'assets/images/travel.png',
      ),
      Vocabulary(
        id: '4',
        word: 'Address',
        meaning:
            'The particulars of the place where someone lives or an organization is situated',
        exampleSentence: 'Please provide your home address.',
        imageUrl: 'assets/images/address.png',
      ),
      Vocabulary(
        id: '5',
        word: 'Addition',
        meaning: 'The process of adding numbers',
        exampleSentence: 'The addition of 5 and 3 equals 8.',
        imageUrl: 'assets/images/addition.png',
      ),
      Vocabulary(
        id: '6',
        word: 'Fruit',
        meaning:
            'The sweet and fleshy product of a tree or other plant that contains seed',
        exampleSentence: 'Apples and oranges are fruits.',
        imageUrl: 'assets/images/fruit.png',
      ),
    ];

    // Sample topic data
    _allTopics = [
      Topic(id: '1', name: 'Animals', imageUrl: 'assets/images/animals.png'),
      Topic(id: '2', name: 'Health', imageUrl: 'assets/images/health.png'),
      Topic(id: '3', name: 'Food', imageUrl: 'assets/images/food.png'),
      Topic(id: '4', name: 'Nature', imageUrl: 'assets/images/nature.png'),
      Topic(id: '5', name: 'Fruits', imageUrl: 'assets/images/fruits.png'),
      Topic(
        id: '6',
        name: 'Mathematics',
        imageUrl: 'assets/images/mathematics.png',
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Simulate network delay
      setState(() {
        _isLoading = true;
        _searchQuery = query.toLowerCase();
      });

      // Simulate API call delay
      Future.delayed(const Duration(seconds: 1), () {
        if (query.isEmpty) {
          setState(() {
            _filteredVocabulary = [];
            _filteredTopics = [];
            _isLoading = false;
          });
          return;
        }

        // Filter vocabulary
        final filteredVocab =
            _allVocabulary.where((vocab) {
              return vocab.word.toLowerCase().contains(_searchQuery) ||
                  vocab.meaning.toLowerCase().contains(_searchQuery);
            }).toList();

        // Filter topics
        final filteredTopics =
            _allTopics.where((topic) {
              return topic.name.toLowerCase().contains(_searchQuery);
            }).toList();

        setState(() {
          _filteredVocabulary = filteredVocab;
          _filteredTopics = filteredTopics;
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search vocab or topic...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                tabs: const [Tab(text: 'Vocab'), Tab(text: 'Topic')],
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                indicatorSize: TabBarIndicatorSize.label,
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Vocabulary Tab
          _buildVocabularyTab(),

          // Topic Tab
          _buildTopicTab(),
        ],
      ),
    );
  }

  Widget _buildVocabularyTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchController.text.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Search for vocabulary',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Type in the search bar to find vocabulary',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (_filteredVocabulary.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sentiment_dissatisfied,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No vocabulary found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'No results for "$_searchQuery"',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _filteredVocabulary.length,
      itemBuilder: (context, index) {
        return VocabularyCard(vocabulary: _filteredVocabulary[index]);
      },
    );
  }

  Widget _buildTopicTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchController.text.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Search for topics',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Type in the search bar to find topics',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (_filteredTopics.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sentiment_dissatisfied,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No topics found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'No results for "$_searchQuery"',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: _filteredTopics.length,
      itemBuilder: (context, index) {
        return TopicCard(topic: _filteredTopics[index]);
      },
    );
  }
}
