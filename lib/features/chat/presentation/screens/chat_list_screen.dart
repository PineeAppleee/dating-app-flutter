import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/mock_data.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Messages",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.only(bottom: 100), // Space for Floating Navigation
        itemCount: MockData.chats.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final chat = MockData.chats[index];
          return ListTile(
            onTap: () => context.push('/chats/detail', extra: chat.user),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(chat.user.imageUrl),
                  backgroundColor: Colors.grey[800],
                ),
                if (chat.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              chat.user.name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              chat.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: chat.unreadCount > 0 ? null : Colors.grey,
                fontWeight: chat.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat.lastMessageTime,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
                if (chat.unreadCount > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      chat.unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
