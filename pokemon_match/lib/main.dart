// main.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const PokemonTripleMatchApp());
}

class PokemonTripleMatchApp extends StatelessWidget {
  const PokemonTripleMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon Triple Match',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    
    // Navigate to tutorial screen after animation completes
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TutorialScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade600,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: const Text(
                'Pokemon Triple Match',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _animation,
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<TutorialPage> _tutorialPages = [
    TutorialPage(
      title: 'Welcome to Pokemon Triple Match!',
      description: 'Match 3 identical Pokemon to score points!',
      icon: Icons.casino,
    ),
    TutorialPage(
      title: 'Select Three Pokemon',
      description: 'Tap on three identical Pokemon to make a match. They can be anywhere on the board!',
      icon: Icons.touch_app,
    ),
    TutorialPage(
      title: 'Race Against the Clock',
      description: 'You have 60 seconds to score as many points as possible!',
      icon: Icons.timer,
    ),
    TutorialPage(
      title: 'Special Actions',
      description: 'Use the Shuffle button to rearrange the board if no matches are available.',
      icon: Icons.shuffle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'How to Play',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _tutorialPages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _tutorialPages[index].icon,
                            size: 100,
                            color: Colors.red.shade600,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            _tutorialPages[index].title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              _tutorialPages[index].description,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicator
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      _tutorialPages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Colors.red.shade600
                              : Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                  
                  // Navigation buttons
                  Row(
                    children: [
                      if (_currentPage > 0)
                        ElevatedButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Back'),
                        ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _tutorialPages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            // Last page, start the game
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const GameScreen()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(_currentPage < _tutorialPages.length - 1 ? 'Next' : 'Play Game'),
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

class TutorialPage {
  final String title;
  final String description;
  final IconData icon;

  TutorialPage({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final int gridSize = 5;
  final int totalPokemonTypes = 10;
  late List<List<PokemonTile>> grid;
  bool isLoading = true;
  int score = 0;
  int moves = 30;
  List<Pokemon> availablePokemon = [];
  List<PokemonTile> selectedTiles = [];
  
  // Timer properties
  Timer? _timer;
  int _timeRemaining = 60; // 60 seconds = 1 minute
  bool _isTimerActive = false;
  
  @override
  void initState() {
    super.initState();
    _loadPokemon();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadPokemon() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      // We'll get a selection of Pokémon
      final List<Pokemon> pokemonList = [];
      final Random random = Random();
      
      // Get random Pokemon IDs (avoiding duplicates)
      final Set<int> pokemonIds = {};
      while (pokemonIds.length < totalPokemonTypes) {
        pokemonIds.add(random.nextInt(151) + 1); // First gen Pokemon
      }
      
      // Fetch Pokemon data
      for (final id in pokemonIds) {
        final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final String name = data['name'];
          final String imageUrl = data['sprites']['other']['official-artwork']['front_default'];
          final List<dynamic> typesData = data['types'];
          final String primaryType = typesData[0]['type']['name'];
          
          pokemonList.add(Pokemon(
            id: id,
            name: name,
            imageUrl: imageUrl,
            type: primaryType,
          ));
        }
      }
      
      availablePokemon = pokemonList;
      _initializeGrid();
    } catch (e) {
      print('Error loading Pokemon: $e');
    }
  }

  void _startTimer() {
    if (!_isTimerActive) {
      _isTimerActive = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_timeRemaining > 0) {
            _timeRemaining--;
          } else {
            _timer?.cancel();
            _showGameOverDialog();
          }
        });
      });
    }
  }

  void _initializeGrid() {
    // Initialize grid with random Pokemon
    grid = List.generate(gridSize, (i) {
      return List.generate(gridSize, (j) {
        final randomPokemon = _getRandomPokemon();
        return PokemonTile(
          pokemon: randomPokemon,
          row: i,
          col: j,
        );
      });
    });
    
    // Ensure we have matches available
    _ensureMatchesAvailable();
    
    setState(() {
      isLoading = false;
    });
  }

  Pokemon _getRandomPokemon() {
    final Random random = Random();
    return availablePokemon[random.nextInt(availablePokemon.length)];
  }

  void _ensureMatchesAvailable() {
    // Simple check if matches are available
    if (!_hasAvailableMatches()) {
      // Reshuffle the grid if no matches are available
      _shuffleGrid();
    }
  }

  bool _hasAvailableMatches() {
    // Check horizontally
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j <= gridSize - 3; j++) {
        final Pokemon p1 = grid[i][j].pokemon;
        final Pokemon p2 = grid[i][j+1].pokemon;
        final Pokemon p3 = grid[i][j+2].pokemon;
        if (p1.id == p2.id && p2.id == p3.id) {
          return true;
        }
      }
    }
    
    // Check vertically
    for (int i = 0; i <= gridSize - 3; i++) {
      for (int j = 0; j < gridSize; j++) {
        final Pokemon p1 = grid[i][j].pokemon;
        final Pokemon p2 = grid[i+1][j].pokemon;
        final Pokemon p3 = grid[i+2][j].pokemon;
        if (p1.id == p2.id && p2.id == p3.id) {
          return true;
        }
      }
    }
    
    return false;
  }

  void _shuffleGrid() {
    // Flatten the grid
    final List<Pokemon> allPokemon = [];
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        allPokemon.add(grid[i][j].pokemon);
      }
    }
    
    // Shuffle
    allPokemon.shuffle();
    
    // Rebuild grid
    int index = 0;
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        grid[i][j].pokemon = allPokemon[index++];
      }
    }
    
    // Make sure we have matches after shuffling
    if (!_hasAvailableMatches()) {
      _shuffleGrid(); // Try again
    }
  }

  void _selectTile(int row, int col) {
    // Start timer on first selection
    if (!_isTimerActive) {
      _startTimer();
    }
    
    if (_timeRemaining <= 0) {
      _showGameOverDialog();
      return;
    }
    
    final selectedTile = grid[row][col];
    
    if (selectedTiles.contains(selectedTile)) {
      // Deselect if already selected
      setState(() {
        selectedTiles.remove(selectedTile);
      });
      return;
    }
    
    setState(() {
      selectedTiles.add(selectedTile);
      
      // Check if we have 3 selected tiles
      if (selectedTiles.length == 3) {
        _checkForMatch();
      }
    });
  }

  void _checkForMatch() {
    // Check if all 3 selected tiles have the same Pokemon
    if (selectedTiles[0].pokemon.id == selectedTiles[1].pokemon.id && 
        selectedTiles[1].pokemon.id == selectedTiles[2].pokemon.id) {
      // Match found!
      _handleMatch();
    } else {
      // No match
      setState(() {
        selectedTiles = [];
      });
    }
  }

  void _handleMatch() {
    setState(() {
      // Increase score
      score += 100;
      
      // Clear matched tiles and replace with new ones
      for (final tile in selectedTiles) {
        final randomPokemon = _getRandomPokemon();
        grid[tile.row][tile.col].pokemon = randomPokemon;
      }
      
      // Clear selected tiles
      selectedTiles = [];
      
      // Check if we still have available matches
      _ensureMatchesAvailable();
    });
  }

  void _showGameOverDialog() {
    _timer?.cancel();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your final score: $score',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Time\'s up!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restartGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void _restartGame() {
    _timer?.cancel();
    
    setState(() {
      score = 0;
      _timeRemaining = 60;
      _isTimerActive = false;
      selectedTiles = [];
      _initializeGrid();
    });
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon Triple Match'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Score and timer display
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade300, Colors.blue.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Score: $score',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _formatTime(_timeRemaining),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _timeRemaining <= 10 
                                ? (_timeRemaining % 2 == 0 ? Colors.red : Colors.white) 
                                : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Game grid
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade100, Colors.blue.shade100],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridSize,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: gridSize * gridSize,
                        itemBuilder: (context, index) {
                          final int row = index ~/ gridSize;
                          final int col = index % gridSize;
                          final tile = grid[row][col];
                          final bool isSelected = selectedTiles.contains(tile);
                          
                          return GestureDetector(
                            onTap: () => _selectTile(row, col),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: _getTileColor(tile.pokemon.type, isSelected),
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected 
                                    ? Border.all(color: Colors.yellow, width: 3)
                                    : null,
                                boxShadow: isSelected
                                    ? [BoxShadow(
                                        color: Colors.yellow.withOpacity(0.6),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      )]
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      tile.pokemon.imageUrl,
                                      fit: BoxFit.contain,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded / 
                                                  loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Text(
                                    tile.pokemon.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? Colors.white : Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                
                // Controls
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade300, Colors.red.shade700],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            selectedTiles = [];
                          });
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear Selection'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red.shade700,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _shuffleGrid();
                          setState(() {
                            selectedTiles = [];
                          });
                        },
                        icon: const Icon(Icons.shuffle),
                        label: const Text('Shuffle'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Color _getTileColor(String type, bool isSelected) {
    if (isSelected) {
      return Colors.blue.shade700;
    }
    
    // Return color based on Pokemon type
    switch (type) {
      case 'fire':
        return Colors.orange.shade200;
      case 'water':
        return Colors.blue.shade200;
      case 'grass':
        return Colors.green.shade200;
      case 'electric':
        return Colors.yellow.shade200;
      case 'psychic':
        return Colors.purple.shade200;
      case 'fighting':
        return Colors.red.shade200;
      case 'normal':
        return Colors.grey.shade200;
      case 'poison':
        return Colors.purple.shade300;
      case 'ground':
        return Colors.brown.shade200;
      case 'flying':
        return Colors.indigo.shade200;
      case 'bug':
        return Colors.lightGreen.shade200;
      case 'rock':
        return Colors.grey.shade400;
      case 'ghost':
        return Colors.indigo.shade300;
      case 'ice':
        return Colors.cyan.shade200;
      case 'dragon':
        return Colors.indigo.shade400;
      case 'fairy':
        return Colors.pink.shade200;
      case 'steel':
        return Colors.blueGrey.shade200;
      case 'dark':
        return Colors.grey.shade700;
      default:
        return Colors.grey.shade300;
    }
  }
}

class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final String type;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.type,
  });
}

class PokemonTile {
  Pokemon pokemon;
  final int row;
  final int col;

  PokemonTile({
    required this.pokemon,
    required this.row,
    required this.col,
  });
}