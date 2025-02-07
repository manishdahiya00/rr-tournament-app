import 'package:app/screens/sign_in_screen.dart';
import 'package:app/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayersScreen extends StatefulWidget {
  final String matchId;
  const PlayersScreen({super.key, required this.matchId});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  late Future<List<dynamic>> players;

  void _navigateToLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  Future<List<dynamic>> fetchPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId") ?? "0";
    final securityToken = prefs.getString("securityToken") ?? "0";

    try {
      final dio = Dio();
      final response = await dio.post(
        "${Utils.baseUrl}/players",
        data: {
          "userId": userId,
          "securityToken": securityToken,
          "matchId": widget.matchId
        },
      );

      if (response.statusCode == 201 && response.data["status"] == 200) {
        await prefs.setString(
            "walletBalance", response.data["walletBalance"].toString());
        return response.data["players"] ?? [];
      } else {
        if (mounted) _navigateToLoginScreen();
      }
    } catch (e) {
      _navigateToLoginScreen();
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    players = fetchPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Players",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: Colors.red,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<dynamic>>(
          future: players,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Center(child: Text("Failed to load players."));
            } else if (snapshot.data!.isEmpty) {
              return const Center(child: Text("No players found."));
            }

            final playerList = snapshot.data!;

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: Utils.screenWidth(context),
                child: DataTable(
                  columnSpacing: 20,
                  dataRowMinHeight: 56,
                  dataRowMaxHeight: 70,
                  headingRowColor: WidgetStateColor.resolveWith(
                      (states) => Colors.red.shade100),
                  border: TableBorder.all(color: Colors.black12),
                  columns: const [
                    DataColumn(
                      label: Center(
                        child: Text(
                          "ID",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                          "Player Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: playerList.map((player) {
                    return DataRow(
                      cells: [
                        DataCell(Center(
                            child: Text(
                                (playerList.indexOf(player) + 1).toString()))),
                        DataCell(Center(child: Text(player["name"]))),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
