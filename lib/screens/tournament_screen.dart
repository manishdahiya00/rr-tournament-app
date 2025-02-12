import 'package:app/screens/join_team_screen.dart';
import 'package:app/screens/players_screen.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';

class TournamentScreen extends StatefulWidget {
  final Map match;
  const TournamentScreen({super.key, required this.match});

  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  final TextStyle _headingStyle = const TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  final TextStyle _subTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.darkBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.match["title"] ?? "Tournament",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: Utils.darkBg,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tournament Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.match["image_url"] ?? "",
                width: Utils.screenWidth(context),
                height: Utils.screenHeight(context) * 0.25,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 16),

            // Tournament Title
            Text(widget.match["title"] ?? "Unknown Tournament",
                style: _headingStyle),
            const SizedBox(height: 8),

            // Timing
            Text(widget.match["timing"] ?? "No timing available",
                style: _subTextStyle),
            const SizedBox(height: 16),

            // Match Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMatchInfo(Icons.attach_money, "Entry Fee",
                    widget.match["entry_fee"]?.toString() ?? "0", Colors.green),
                _buildMatchInfo(
                    Icons.emoji_events,
                    "Winning Prize",
                    widget.match["winning_prize"]?.toString() ?? "0",
                    Colors.orange),
                _buildMatchInfo(Icons.local_fire_department, "Per Kill",
                    widget.match["per_kill"]?.toString() ?? "0", Colors.cyan),
              ],
            ),
            const SizedBox(height: 16),

            // Action Buttons (Create Team & Join Team)
            (widget.match["status"] == "upcoming" &&
                    widget.match["slots_left"].toString() != "0")
                ? Row(
                    children: [
                      // Expanded(
                      //     child: _buildActionButton("Create Team", () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => JoinTeamScreen(
                      //                 matchId: widget.match["_id"],
                      // })),
                      // const SizedBox(width: 10),
                      Expanded(
                          child: _buildActionButton("Join Team", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JoinTeamScreen(
                                      match: widget.match,
                                    )));
                      })),
                    ],
                  )
                : const SizedBox(height: 0),
            const SizedBox(height: 10),

            // Players Button
            _buildActionButton("Players", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PlayersScreen(matchId: widget.match["id"])));
            }),
            const SizedBox(height: 16),

            // Rules Section
            const Text("Rules:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            Text(
              widget.match["rules"] ?? "No rules provided.",
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget to display match details like Entry Fee, Winning Prize, Per Kill
  Widget _buildMatchInfo(
      IconData icon, String title, String value, Color iconColor) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400)),
      ],
    );
  }

  /// Widget to create a button with a uniform style
  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Utils.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
