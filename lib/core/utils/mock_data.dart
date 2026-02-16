import 'package:flutter/material.dart';

class UserModel {
  final String id;
  final String name;
  final int age;
  final String imageUrl;
  final String bio;
  final String location;
  final List<String> interests;
  final double distance;

  const UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.bio,
    required this.location,
    required this.interests,
    required this.distance,
  });
}

class MockData {
  static const List<UserModel> users = [
    UserModel(
      id: '1',
      name: 'Jessica',
      age: 24,
      imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=800&q=80',
      bio: 'Travel enthusiast ✈️ | Coffee lover ☕ | Always looking for the next adventure.',
      location: 'New York, USA',
      interests: ['Travel', 'Coffee', 'Photography', 'Yoga'],
      distance: 2.5,
    ),
    UserModel(
      id: '2',
      name: 'James',
      age: 28,
      imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
      bio: 'Tech founder by day, musician by night 🎸. Let’s jam!',
      location: 'Brooklyn, USA',
      interests: ['Music', 'Tech', 'Hiking', 'Guitar'],
      distance: 5.0,
    ),
    UserModel(
      id: '3',
      name: 'Sophia',
      age: 25,
      imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
      bio: 'Art student 🎨. I love galleries, museums, and good wine 🍷.',
      location: 'Manhattan, USA',
      interests: ['Art', 'Wine', 'Museums', 'Drawing'],
      distance: 1.2,
    ),
    UserModel(
      id: '4',
      name: 'Michael',
      age: 30,
      imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=800&q=80',
      bio: 'Fitness freak 💪. Searching for a gym buddy and maybe more.',
      location: 'Queens, USA',
      interests: ['Fitness', 'Gym', 'Running', 'Cooking'],
      distance: 8.0,
    ),
    UserModel(
      id: '5',
      name: 'Emma',
      age: 26,
      imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=800&q=80',
      bio: 'Dog mom 🐶. If you don’t like dogs, we won’t get along.',
      location: 'Bronx, USA',
      interests: ['Dogs', 'Animals', 'Reading', 'Movies'],
      distance: 12.0,
    ),
  ];

  static const List<UserModel> matches = [
    UserModel(
      id: '2',
      name: 'James',
      age: 28,
      imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
      bio: 'Tech founder by day, musician by night 🎸.',
      location: 'Brooklyn, USA',
      interests: ['Music', 'Tech'],
      distance: 5.0,
    ),
     UserModel(
      id: '1',
      name: 'Jessica',
      age: 24,
      imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=800&q=80',
      bio: 'Travel enthusiast ✈️',
      location: 'New York, USA',
      interests: ['Travel', 'Yoga'],
      distance: 2.5,
    ),
  ];
  
  static const List<ChatModel> chats = [
    ChatModel(
      id: '1',
      user: UserModel(
        id: '2',
        name: 'James',
        age: 28,
        imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
        bio: '', location: '', interests: [], distance: 0,
      ),
      lastMessage: 'Hey! Are you coming to the concert tonight?',
      lastMessageTime: '10:30 AM',
      unreadCount: 2,
      isOnline: true,
    ),
    ChatModel(
      id: '2',
      user: UserModel(
        id: '3',
        name: 'Sophia',
        age: 25,
        imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
        bio: '', location: '', interests: [], distance: 0,
      ),
      lastMessage: 'I loved that gallery too! 😍',
      lastMessageTime: 'Yesterday',
      unreadCount: 0,
      isOnline: false,
    ),
  ];

  static const List<MessageModel> messages = [
    MessageModel(text: "Hey! How are you?", isMe: false, time: "10:00 AM"),
    MessageModel(text: "I'm doing great, thanks! How about you?", isMe: true, time: "10:05 AM"),
    MessageModel(text: "Pretty good. Just working on some code.", isMe: false, time: "10:10 AM"),
    MessageModel(text: "Nice! What stack are you using?", isMe: true, time: "10:12 AM"),
    MessageModel(text: "Flutter, obviously! 💙", isMe: false, time: "10:15 AM"),
  ];
}

class ChatModel {
  final String id;
  final UserModel user;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  const ChatModel({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isOnline,
  });
}

class MessageModel {
  final String text;
  final bool isMe;
  final String time;

  const MessageModel({
    required this.text,
    required this.isMe,
    required this.time,
  });
}
