import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> cocktails = [];
  TextEditingController searchController = TextEditingController();
  String? selectedIngredient = 'Vodka'; // Menggunakan tipe data nullable
  List<String> ingredients = [
    'Vodka',
    'Gin',
    'Rum',
    'Tequila',
    'Whiskey',
    'Brandy',
    'Champagne',
    'Triple sec',
    'Kahlua',
  ];
  String? selectedAlcoholic = 'Alcoholic'; // Menggunakan tipe data nullable
  List<String> alcoholics = ['Alcoholic', 'Non_Alcoholic'];
  String? selectedGlass = 'Highball glass'; // Menggunakan tipe data nullable
  List<String> glasses = [
    'Highball glass',
    'Cocktail glass',
    'Old-fashioned glass',
    'Collins glass',
    'Pousse cafe glass',
    'Champagne flute',
    'Whiskey sour glass',
    'Brandy snifter',
    'White wine glass',
    'Nick and Nora Glass',
  ];

  @override
  void initState() {
    super.initState();
    fetchCocktails();
  }

  Future<void> fetchCocktails() async {
    final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/search.php?s=${searchController.text}'));
    if (response.statusCode == 200) {
      setState(() {
        cocktails = jsonDecode(response.body)['drinks'];
      });
    } else {
      throw Exception('Failed to load cocktails');
    }
  }

  // Fungsi konversi mata uang
  double convertToDollar(double amount) {
    return amount * 0.000070;
  }

  double convertToYen(double amount) {
    return amount * 7.68;
  }

  double convertToRinggit(double amount) {
    return amount * 0.29;
  }

  // Fungsi konversi waktu
  String convertToWIT(String wibTime) {
    // Konversi waktu dari WIB ke WIT
    // WIT lebih lambat 1 jam dari WIB
    DateTime wibDateTime = DateTime.parse(wibTime);
    DateTime witDateTime = wibDateTime.add(Duration(hours: 1));
    return witDateTime.toString();
  }

  String convertToWITA(String wibTime) {
    // Konversi waktu dari WIB ke WITA
    // WITA lebih lambat 2 jam dari WIB
    DateTime wibDateTime = DateTime.parse(wibTime);
    DateTime witaDateTime = wibDateTime.add(Duration(hours: 2));
    return witaDateTime.toString();
  }

  String convertToLondonTime(String wibTime) {
    // Konversi waktu dari WIB ke waktu London
    // Waktu London lebih cepat 7 jam dari WIB
    DateTime wibDateTime = DateTime.parse(wibTime);
    DateTime londonDateTime = wibDateTime.subtract(Duration(hours: 7));
    return londonDateTime.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cocktails'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Lakukan proses logout di sini
              // Contoh sederhana: kembali ke halaman login
              Navigator.pop(context); // Kembali ke halaman sebelumnya (biasanya login)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: fetchCocktails,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String>(
                value: selectedIngredient,
                onChanged: (String? newValue) { // Menggunakan tipe data nullable
                  setState(() {
                    selectedIngredient = newValue;
                  });
                  fetchCocktails();
                },
                items: ingredients.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: selectedAlcoholic,
                onChanged: (String? newValue) { // Menggunakan tipe data nullable
                  setState(() {
                    selectedAlcoholic = newValue;
                  });
                  fetchCocktails();
                },
                items: alcoholics.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: selectedGlass,
                onChanged: (String? newValue) { // Menggunakan tipe data nullable
                  setState(() {
                    selectedGlass = newValue;
                  });
                  fetchCocktails();
                },
                items: glasses.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cocktails.length,
              itemBuilder: (context, index) {
                final cocktail = cocktails[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(cocktail['strDrinkThumb']),
                  ),
                  title: Text(cocktail['strDrink']),
                  subtitle: Text(cocktail['strCategory']),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {}, // Tambahkan fungsi navigasi ke halaman utama
            ),
            IconButton(
              icon: Icon(Icons.attach_money),
              onPressed: () {
                // Tampilkan dialog untuk memasukkan jumlah uang yang akan dikonversi
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Convert Currency"),
                      content: TextField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true), // Hapus batasan input nominal uang
                        decoration: InputDecoration(labelText: "Enter Amount in Rupiah"),
                        onChanged: (String value) {
                          // Convert nilai yang dimasukkan menjadi tipe data double
                          double amount = double.tryParse(value) ?? 0.0;
                          // Tampilkan hasil konversi mata uang dalam dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Conversion Results"),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Rupiah to Dollar: \$${convertToDollar(amount).toStringAsFixed(2)}"),
                                    Text("Rupiah to Yen: ¥${convertToYen(amount).toStringAsFixed(2)}"),
                                    Text("Rupiah to Ringgit: RM${convertToRinggit(amount).toStringAsFixed(2)}"),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Close"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.access_time),
              onPressed: () {
                // Tampilkan dialog untuk konversi waktu
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Convert Time"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("WIB Time: ${DateTime.now()}"),
                          Text("WIT Time: ${convertToWIT(DateTime.now().toString())}"),
                          Text("WITA Time: ${convertToWITA(DateTime.now().toString())}"),
                          Text("London Time: ${convertToLondonTime(DateTime.now().toString())}"),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: CircleAvatar(
                radius: 12,
                backgroundImage: AssetImage('assets/ismed.jpg'),
              ),
              onPressed: () {
                // Navigasi ke halaman "Profile"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TimePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Page'),
      ),
      body: Center(
        child: Text('This is the Time Page'),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/yudok.jpg'), // Ganti dengan path gambar Anda
            ),
            SizedBox(height: 20),
            Text(
              'Ismed Yudha Swandana',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'TEKNOLOGI PEMROGRAMAN MOBILE - 123210134',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
