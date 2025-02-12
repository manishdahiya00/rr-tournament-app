import 'dart:ui';

import 'package:app/screens/sign_in_screen.dart';
import 'package:app/screens/tournament_screen.dart';
import 'package:app/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TournamentsScreen extends StatefulWidget {
  String categoryId;
  TournamentsScreen({super.key, required this.categoryId});

  @override
  State<TournamentsScreen> createState() => _TournamentsScreenState();
}

class _TournamentsScreenState extends State<TournamentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.darkBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          Utils.appName,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Utils.darkBg,
        bottom: TabBar(
          dividerHeight: 0,
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.white,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Ongoing'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MatchesTab(
              apiEndpoint: "/upcomingMatches", categoryId: widget.categoryId),
          MatchesTab(
              apiEndpoint: "/liveMatches", categoryId: widget.categoryId),
          MatchesTab(
              apiEndpoint: "/completedMatches", categoryId: widget.categoryId),
        ],
      ),
    );
  }
}

class MatchesTab extends StatefulWidget {
  final String apiEndpoint;
  final String categoryId;
  const MatchesTab(
      {super.key, required this.apiEndpoint, required this.categoryId});

  @override
  State<MatchesTab> createState() => _MatchesTabState();
}

class _MatchesTabState extends State<MatchesTab> {
  void _navigateToLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  Future<Map<String, dynamic>> fetchMatches() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId") ?? "0";
    final securityToken = prefs.getString("securityToken") ?? "0";

    try {
      final dio = Dio();
      final response = await dio.post(
        "${Utils.baseUrl}${widget.apiEndpoint}",
        data: {
          "userId": userId,
          "securityToken": securityToken,
          "categoryId": widget.categoryId
        },
      );

      if (response.statusCode == 201 && response.data["status"] == 200) {
        await prefs.setString(
            "walletBalance", response.data["walletBalance"].toString());
        return response.data;
      } else {
        if (mounted) _navigateToLoginScreen();
      }
    } catch (e) {
      if (mounted) _navigateToLoginScreen();
    }
    return {"matches": []};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchMatches(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.cyan),
          );
        }

        final data = snapshot.data!;
        if (data.containsKey("error")) {
          Future.microtask(() => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
              ));
          return const SizedBox.shrink();
        }

        final matches = data["matches"] ?? [];

        if (matches.isEmpty) {
          return const Center(
              child: Text(
            "No Matches found",
            style: TextStyle(color: Colors.white),
          ));
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            return MatchCard(match: match);
          },
        );
      },
    );
  }
}

class MatchCard extends StatelessWidget {
  final Map<String, dynamic> match;
  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        splashColor: Utils.secondaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        highlightColor: Utils.secondaryColor.withOpacity(0.5),
        focusColor: Utils.secondaryColor.withOpacity(0.5),
        hoverColor: Utils.secondaryColor.withOpacity(0.5),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TournamentScreen(match: match),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Card(
              color: Utils.secondaryColor.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset("assets/images/logo.png",
                            height: 50, width: 50)),
                    title: Text(
                      match["title"] ?? "Unknown Match",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      match["timing"] ?? "No timing info",
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.monetization_on,
                            color: Utils.primaryColor, size: 16),
                        const SizedBox(width: 10),
                        Text(
                          "${match["entry_fee"]?.toString() ?? 0} PP",
                          style: const TextStyle(
                            color: Utils.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        match["room_id"] != ""
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Room Id: ${match["room_id"]}",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: match["room_id"]));

                                            Utils.showSnackbar(context,
                                                message:
                                                    "Room Id Copied Successfully");
                                          },
                                          icon: const Icon(
                                            Icons.copy,
                                            size: 15,
                                            color: Utils.primaryColor,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Room Password: ${match["room_pass"]}",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: match["room_pass"]));

                                            Utils.showSnackbar(context,
                                                message:
                                                    "Room Pass Copied Successfully");
                                          },
                                          icon: const Icon(
                                            Icons.copy,
                                            size: 15,
                                            color: Utils.primaryColor,
                                          )),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${match["total_slots"]} Slots",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                            Text(
                              "${match["slots_left"]} Remaining Slots",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        LinearProgressIndicator(
                          value: ((match["total_slots"] - match["slots_left"]) /
                              (match["total_slots"])),
                          color: Utils.primaryColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          match["subtitle"] ?? "No additional info",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
