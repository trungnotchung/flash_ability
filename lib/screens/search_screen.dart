import 'package:flutter/material.dart';
import 'dart:async';
import '../models/vocabulary.dart';
import '../models/topic.dart';
import '../widgets/vocabulary_card.dart';
import '../widgets/topic_card.dart';
import '../mock_data/flashcards.dart';
import '../mock_data/topics.dart';

// Helper function for getting topic icons
IconData _getTopicIcon(String topicName) {
  // Map topic names to appropriate icons
  switch (topicName.toLowerCase()) {
    case 'family':
      return Icons.family_restroom;
    case 'school':
      return Icons.school;
    case 'animal':
      return Icons.pets;
    case 'sport':
      return Icons.sports_soccer;
    case 'food':
      return Icons.restaurant;
    case 'weather':
      return Icons.cloud;
    case 'country':
      return Icons.public;
    case 'nature':
      return Icons.nature;
    default:
      return Icons.category;
  }
}

// Helper function for getting topic colors
Color _getTopicColor(String topicName) {
  switch (topicName.toLowerCase()) {
    case 'family':
      return Colors.blue;
    case 'school':
      return Colors.orange;
    case 'animal':
      return Colors.brown;
    case 'sport':
      return Colors.green;
    case 'food':
      return Colors.red;
    case 'weather':
      return Colors.lightBlue;
    case 'country':
      return Colors.purple;
    case 'nature':
      return Colors.teal;
    default:
      return Colors.indigo;
  }
}

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

  // List to store search history
  List<String> _searchHistory = [];
  // Maximum number of history items to store
  final int _maxHistoryItems = 5;
  // Flag to show/hide search history
  bool _showSearchHistory = false;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load data from mock files
    _loadMockData();

    // Add focus listener to show history when search field is focused
    _searchController.addListener(_onSearchFocusChange);
  }

  void _onSearchFocusChange() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _showSearchHistory = true;
      });
    } else {
      setState(() {
        _showSearchHistory = false;
      });
    }
  }

  void _loadMockData() {
    // Convert flashcards data to Vocabulary objects and filter out items without valid images
    _allVocabulary =
        flashcards
            .where(
              (flashcard) =>
                  flashcard['image'] != null &&
                  flashcard['image'].toString().isNotEmpty,
            )
            .map((flashcard) {
              return Vocabulary(
                id: flashcard['word'] ?? '',
                word: flashcard['word'] ?? '',
                meaning: flashcard['description'] ?? '',
                exampleSentence: '', // No example sentence in mock data
                imageUrl:
                    'assets/images/${flashcard['image'] ?? 'placeholder.png'}',
              );
            })
            .toList();

    // Convert topics data to Topic objects
    _allTopics =
        topicsWithVocab.map((topicData) {
          final topicName = topicData['topic'] as String;
          return Topic(
            id: topicName,
            name: topicName,
            imageUrl: 'assets/images/${topicName.toLowerCase()}.png',
          );
        }).toList();
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

    setState(() {
      _showSearchHistory = query.isEmpty;
    });

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

          // Add to search history if results were found and query is not empty
          if ((filteredVocab.isNotEmpty || filteredTopics.isNotEmpty) &&
              query.isNotEmpty &&
              !_searchHistory.contains(query)) {
            _addToSearchHistory(query);
          }
        });
      });
    });
  }

  void _addToSearchHistory(String query) {
    setState(() {
      // Remove query if it already exists to avoid duplicates
      _searchHistory.remove(query);
      // Add the new query at the beginning of the list
      _searchHistory.insert(0, query);
      // Keep only the most recent searches
      if (_searchHistory.length > _maxHistoryItems) {
        _searchHistory = _searchHistory.sublist(0, _maxHistoryItems);
      }
    });
  }

  void _useHistoryQuery(String query) {
    _searchController.text = query;
    _onSearchChanged(query);
    // Move this query to the top of history
    _addToSearchHistory(query);
  }

  void _clearHistory() {
    setState(() {
      _searchHistory.clear();
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
          Stack(
            children: [
              _buildVocabularyTab(),
              if (_showSearchHistory && _searchHistory.isNotEmpty)
                _buildSearchHistory(),
            ],
          ),

          // Topic Tab
          Stack(
            children: [
              _buildTopicTab(),
              if (_showSearchHistory && _searchHistory.isNotEmpty)
                _buildSearchHistory(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistory() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (_searchHistory.isNotEmpty)
                  TextButton(
                    onPressed: _clearHistory,
                    child: const Text('Clear All'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(_searchHistory[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () {
                      setState(() {
                        _searchHistory.removeAt(index);
                      });
                    },
                  ),
                  onTap: () => _useHistoryQuery(_searchHistory[index]),
                );
              },
            ),
          ),
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
        crossAxisCount: 2,
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
        final topic = _filteredTopics[index];
        // Use custom card with icon instead of TopicCard widget
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/learning/topic',
                arguments: topic.name,
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getTopicColor(topic.name).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getTopicIcon(topic.name),
                        size: 40,
                        color: _getTopicColor(topic.name),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      topic.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
