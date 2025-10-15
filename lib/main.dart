import 'package:flutter/material.dart';

void main() {
  runApp(const NutritionApp());
}

class NutritionApp extends StatelessWidget {
  const NutritionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrition Tracker',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(primarySwatch: Colors.green),

      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> meals = [];

  void _addMeal(Map<String, dynamic> meal) {
    setState(() {
      meals.add(meal);
    });
  }

  void _deleteMeal(int index) {
    setState(() {
      meals.removeAt(index);
    });
  }

  int get totalCalories {
    return meals.fold(0, (sum, meal) => sum + (meal['calories'] as int));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition Tracker'), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Text(
              "Calories totales : $totalCalories kcal",

              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: meals.length,

                itemBuilder: (context, index) {
                  final meal = meals[index];

                  return Card(
                    child: ListTile(
                      title: Text(meal['name']),

                      subtitle: Text(
                        "${meal['category']} - ${meal['calories']} kcal",
                      ),

                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),

                        onPressed: () => _deleteMeal(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newMeal = await Navigator.push(
            context,

            MaterialPageRoute(builder: (context) => const AddMealPage()),
          );

          if (newMeal != null) {
            _addMeal(newMeal);
          }
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController caloriesController = TextEditingController();

  String category = 'Déjeuner';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un repas')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: nameController,

              decoration: const InputDecoration(labelText: 'Nom du repas'),
            ),

            TextField(
              controller: caloriesController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: 'Calories'),
            ),

            DropdownButton<String>(
              value: category,

              items: [
                'Petit-déj',
                'Déjeuner',
                'Dîner',
                'Snack',
              ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),

              onChanged: (value) {
                setState(() => category = value!);
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    caloriesController.text.isNotEmpty) {
                  final newMeal = {
                    'name': nameController.text,

                    'calories': int.parse(caloriesController.text),

                    'category': category,

                    'date': DateTime.now().toString(),
                  };

                  Navigator.pop(context, newMeal);
                }
              },

              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
