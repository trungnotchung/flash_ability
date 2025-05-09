List<Map<String, dynamic>> communityGroups = [
  {'groupName': 'Flashcard Enthusiasts', 'membersCount': 120},
  {'groupName': 'Language Learners', 'membersCount': 250},
  {'groupName': 'Study Buddies', 'membersCount': 80},
];

List<Map<String, dynamic>> recentActivities = [
  // Language Learners
  {
    'user': 'User 1',
    'activityTime': '1 hour ago',
    'activityType': 'Q&A',
    'post': 'What’s the best way to memorize vocabulary?',
    'likes': 5,
    'comments': 2,
    'group': 'Language Learners',
    'commentsData': [
      {
        'user': 'User 2',
        'comment': 'Try using spaced repetition for better memory.',
        'timestamp': '50 minutes ago',
      },
      {
        'user': 'User 3',
        'comment': 'I find flashcards very effective!',
        'timestamp': '30 minutes ago',
      },
    ],
  },
  {
    'user': 'User 4',
    'activityTime': '3 hours ago',
    'activityType': 'Tips',
    'post': 'Immerse yourself in media from your target language.',
    'likes': 7,
    'comments': 1,
    'group': 'Language Learners',
    'commentsData': [
      {
        'user': 'User 5',
        'comment': 'Watching movies has helped me a lot!',
        'timestamp': '2 hours ago',
      },
    ],
  },
  {
    'user': 'User 6',
    'activityTime': '5 hours ago',
    'activityType': 'Discussion',
    'post': 'How often do you practice speaking your new language?',
    'likes': 9,
    'comments': 2,
    'group': 'Language Learners',
    'commentsData': [
      {
        'user': 'User 7',
        'comment': 'Every day for 10 minutes!',
        'timestamp': '3 hours ago',
      },
      {
        'user': 'User 8',
        'comment': 'Only on weekends.',
        'timestamp': '2 hours ago',
      },
    ],
  },
  {
    'user': 'User 1',
    'activityTime': '1 day ago',
    'activityType': 'Q&A',
    'post': 'Is it better to learn grammar or vocabulary first?',
    'likes': 4,
    'comments': 3,
    'group': 'Language Learners',
    'commentsData': [
      {
        'user': 'User 2',
        'comment': 'I recommend both in parallel.',
        'timestamp': '22 hours ago',
      },
      {
        'user': 'User 5',
        'comment': 'Start with vocabulary.',
        'timestamp': '20 hours ago',
      },
      {
        'user': 'User 9',
        'comment': 'Grammar helps with sentence structure.',
        'timestamp': '18 hours ago',
      },
    ],
  },
  {
    'user': 'User 10',
    'activityTime': '2 days ago',
    'activityType': 'Tips',
    'post': 'Try shadowing technique to improve pronunciation.',
    'likes': 6,
    'comments': 1,
    'group': 'Language Learners',
    'commentsData': [
      {
        'user': 'User 3',
        'comment': 'It really works!',
        'timestamp': '1 day ago',
      },
    ],
  },
  {
    'user': 'User 3',
    'activityTime': '3 days ago',
    'activityType': 'Discussion',
    'post': 'Which language app do you prefer?',
    'likes': 8,
    'comments': 2,
    'group': 'Language Learners',
    'commentsData': [
      {
        'user': 'User 4',
        'comment': 'I love Duolingo.',
        'timestamp': '2 days ago',
      },
      {
        'user': 'User 7',
        'comment': 'Busuu is more practical.',
        'timestamp': '2 days ago',
      },
    ],
  },

  // Flashcard Enthusiasts
  {
    'user': 'User 2',
    'activityTime': '1 day ago',
    'activityType': 'Tips',
    'post': 'Flashcards are a great way to retain words!',
    'likes': 3,
    'comments': 1,
    'group': 'Flashcard Enthusiasts',
    'commentsData': [
      {
        'user': 'User 4',
        'comment': 'I totally agree. They work wonders for me.',
        'timestamp': '12 hours ago',
      },
    ],
  },
  {
    'user': 'User 5',
    'activityTime': '10 hours ago',
    'activityType': 'Q&A',
    'post': 'What’s your favorite flashcard app?',
    'likes': 2,
    'comments': 2,
    'group': 'Flashcard Enthusiasts',
    'commentsData': [
      {
        'user': 'User 6',
        'comment': 'Anki, definitely!',
        'timestamp': '8 hours ago',
      },
      {
        'user': 'User 9',
        'comment': 'I prefer Quizlet.',
        'timestamp': '7 hours ago',
      },
    ],
  },
  {
    'user': 'User 7',
    'activityTime': '18 hours ago',
    'activityType': 'Discussion',
    'post': 'How many flashcards do you review per day?',
    'likes': 6,
    'comments': 2,
    'group': 'Flashcard Enthusiasts',
    'commentsData': [
      {'user': 'User 2', 'comment': 'Around 50.', 'timestamp': '17 hours ago'},
      {
        'user': 'User 10',
        'comment': 'I do 30 daily.',
        'timestamp': '16 hours ago',
      },
    ],
  },
  {
    'user': 'User 8',
    'activityTime': '2 days ago',
    'activityType': 'Tips',
    'post': 'Use images and audio in your flashcards!',
    'likes': 4,
    'comments': 1,
    'group': 'Flashcard Enthusiasts',
    'commentsData': [
      {
        'user': 'User 1',
        'comment': 'It makes learning more fun.',
        'timestamp': '1 day ago',
      },
    ],
  },
  {
    'user': 'User 6',
    'activityTime': '3 days ago',
    'activityType': 'Q&A',
    'post': 'How do you handle too many due cards in Anki?',
    'likes': 5,
    'comments': 2,
    'group': 'Flashcard Enthusiasts',
    'commentsData': [
      {
        'user': 'User 3',
        'comment': 'Suspend some decks temporarily.',
        'timestamp': '2 days ago',
      },
      {
        'user': 'User 9',
        'comment': 'Prioritize by subject.',
        'timestamp': '2 days ago',
      },
    ],
  },
  {
    'user': 'User 10',
    'activityTime': '4 days ago',
    'activityType': 'Discussion',
    'post': 'Manual flashcards vs. digital ones?',
    'likes': 7,
    'comments': 3,
    'group': 'Flashcard Enthusiasts',
    'commentsData': [
      {
        'user': 'User 5',
        'comment': 'Digital is easier to manage.',
        'timestamp': '3 days ago',
      },
      {
        'user': 'User 6',
        'comment': 'But manual helps memory better.',
        'timestamp': '3 days ago',
      },
      {
        'user': 'User 7',
        'comment': 'Depends on your learning style.',
        'timestamp': '2 days ago',
      },
    ],
  },

  // Study Buddies
  {
    'user': 'User 3',
    'activityTime': '2 days ago',
    'activityType': 'Discussion',
    'post': 'How do you manage your study schedule?',
    'likes': 8,
    'comments': 5,
    'group': 'Study Buddies',
    'commentsData': [
      {
        'user': 'User 1',
        'comment': 'I set a timer for 30-minute study sessions.',
        'timestamp': '1 day ago',
      },
      {
        'user': 'User 5',
        'comment': 'I use a study planner to keep track of my tasks.',
        'timestamp': '20 hours ago',
      },
      {
        'user': 'User 6',
        'comment': 'Try using the Pomodoro technique for better productivity.',
        'timestamp': '18 hours ago',
      },
      {
        'user': 'User 7',
        'comment': 'I study for 45 minutes and then take a 15-minute break.',
        'timestamp': '16 hours ago',
      },
      {
        'user': 'User 8',
        'comment': 'I break down my study material into smaller chunks.',
        'timestamp': '14 hours ago',
      },
    ],
  },
  {
    'user': 'User 4',
    'activityTime': '1 day ago',
    'activityType': 'Tips',
    'post': 'Create a consistent daily study routine.',
    'likes': 4,
    'comments': 1,
    'group': 'Study Buddies',
    'commentsData': [
      {
        'user': 'User 2',
        'comment': 'Routine really builds discipline.',
        'timestamp': '22 hours ago',
      },
    ],
  },
  {
    'user': 'User 5',
    'activityTime': '3 days ago',
    'activityType': 'Q&A',
    'post': 'How do you stay focused while studying at home?',
    'likes': 6,
    'comments': 2,
    'group': 'Study Buddies',
    'commentsData': [
      {
        'user': 'User 9',
        'comment': 'I use focus music or white noise.',
        'timestamp': '2 days ago',
      },
      {
        'user': 'User 10',
        'comment': 'Clear workspace helps a lot.',
        'timestamp': '2 days ago',
      },
    ],
  },
  {
    'user': 'User 6',
    'activityTime': '2 days ago',
    'activityType': 'Tips',
    'post': 'Use to-do lists to track your study goals.',
    'likes': 5,
    'comments': 2,
    'group': 'Study Buddies',
    'commentsData': [
      {
        'user': 'User 3',
        'comment': 'I use Notion for this.',
        'timestamp': '1 day ago',
      },
      {
        'user': 'User 4',
        'comment': 'Sticky notes on the wall!',
        'timestamp': '1 day ago',
      },
    ],
  },
  {
    'user': 'User 9',
    'activityTime': '4 days ago',
    'activityType': 'Discussion',
    'post': 'Study alone or with a partner—which is more effective?',
    'likes': 9,
    'comments': 3,
    'group': 'Study Buddies',
    'commentsData': [
      {
        'user': 'User 1',
        'comment': 'I prefer solo focus.',
        'timestamp': '3 days ago',
      },
      {
        'user': 'User 5',
        'comment': 'Study partner keeps me accountable.',
        'timestamp': '3 days ago',
      },
      {
        'user': 'User 6',
        'comment': 'Depends on the topic.',
        'timestamp': '2 days ago',
      },
    ],
  },
];
