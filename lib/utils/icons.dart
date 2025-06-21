import 'package:flutter/material.dart';

class AppIcons {
  // Navigation icons
  static const IconData home = Icons.home;
  static const IconData events = Icons.sports_basketball;
  static const IconData rooms = Icons.chat_bubble;
  static const IconData profile = Icons.person;
  
  // Sports icons
  static const IconData basketball = Icons.sports_basketball;
  static const IconData football = Icons.sports_football;
  static const IconData soccer = Icons.sports_soccer;
  static const IconData tennis = Icons.sports_tennis;
  static const IconData cricket = Icons.sports_cricket;
  static const IconData baseball = Icons.sports_baseball;
  static const IconData volleyball = Icons.sports_volleyball;
  static const IconData hockey = Icons.sports_hockey;
  static const IconData motorsports = Icons.sports_motorsports;
  static const IconData esports = Icons.videogame_asset;
  static const IconData otherSports = Icons.fitness_center;
  
  // Room icons
  static const IconData chatRoom = Icons.chat;
  static const IconData liveRoom = Icons.live_tv;
  static const IconData privateRoom = Icons.lock;
  static const IconData publicRoom = Icons.public;
  static const IconData savedRoom = Icons.bookmark;
  static const IconData createRoom = Icons.add_circle;
  static const IconData joinRoom = Icons.login;
  static const IconData leaveRoom = Icons.exit_to_app;
  static const IconData forkRoom = Icons.fork_right;
  
  // User icons
  static const IconData captain = Icons.star;
  static const IconData moderator = Icons.shield;
  static const IconData member = Icons.person;
  static const IconData guest = Icons.person_outline;
  
  // Auth icons
  static const IconData login = Icons.login;
  static const IconData register = Icons.app_registration;
  static const IconData logout = Icons.logout;
  static const IconData forgotPassword = Icons.lock_reset;
  static const IconData verified = Icons.verified;
  static const IconData email = Icons.email;
  static const IconData password = Icons.password;
  
  // Message icons
  static const IconData send = Icons.send;
  static const IconData attachment = Icons.attach_file;
  static const IconData image = Icons.image;
  static const IconData camera = Icons.camera_alt;
  static const IconData voiceMessage = Icons.mic;
  static const IconData emoji = Icons.emoji_emotions;
  static const IconData read = Icons.done_all;
  static const IconData delivered = Icons.done;
  
  // UI icons
  static const IconData edit = Icons.edit;
  static const IconData delete = Icons.delete;
  static const IconData save = Icons.save;
  static const IconData cancel = Icons.close;
  static const IconData search = Icons.search;
  static const IconData filter = Icons.filter_list;
  static const IconData sort = Icons.sort;
  static const IconData refresh = Icons.refresh;
  static const IconData settings = Icons.settings;
  static const IconData info = Icons.info;
  static const IconData notification = Icons.notifications;
  static const IconData trending = Icons.trending_up;
  static const IconData calendar = Icons.calendar_today;
  static const IconData time = Icons.access_time;
  static const IconData participants = Icons.people;
  static const IconData messages = Icons.message;
  
  // Status icons
  static const IconData online = Icons.circle;
  static const IconData offline = Icons.circle_outlined;
  static const IconData away = Icons.schedule;
  static const IconData busy = Icons.do_not_disturb_on;
  static const IconData typing = Icons.keyboard;
  
  // Other icons
  static const IconData darkMode = Icons.dark_mode;
  static const IconData lightMode = Icons.light_mode;
  static const IconData help = Icons.help;
  static const IconData about = Icons.info;
  static const IconData rate = Icons.star_rate;
  static const IconData share = Icons.share;
  static const IconData link = Icons.link;
  static const IconData copy = Icons.content_copy;
  static const IconData report = Icons.report_problem;
  static const IconData warning = Icons.warning;
  static const IconData error = Icons.error;
  static const IconData success = Icons.check_circle;
  
  // Get sport icon by category
  static IconData getSportIcon(String category) {
    switch (category.toLowerCase()) {
      case 'basketball':
        return basketball;
      case 'football':
      case 'american football':
        return football;
      case 'soccer':
        return soccer;
      case 'tennis':
        return tennis;
      case 'cricket':
        return cricket;
      case 'baseball':
        return baseball;
      case 'volleyball':
        return volleyball;
      case 'hockey':
      case 'ice hockey':
        return hockey;
      case 'formula 1':
      case 'racing':
      case 'motorsports':
        return motorsports;
      case 'esports':
      case 'gaming':
        return esports;
      default:
        return otherSports;
    }
  }
  
  // Get participant icon by tier
  static IconData getParticipantIcon(String tier) {
    switch (tier.toLowerCase()) {
      case 'captain':
        return captain;
      case 'moderator':
        return moderator;
      case 'member':
        return member;
      case 'guest':
      default:
        return guest;
    }
  }
}
