//This Project is inspired from  (https://github.com/Sangwan5688/BlackHole) 

import 'package:hive/hive.dart';

void addSongsCount(String playlistName, int len, List images) {
  final Map playlistDetails =
      Hive.box('settings').get('playlistDetails', defaultValue: {}) as Map;
  if (playlistDetails.containsKey(playlistName)) {
    playlistDetails[playlistName].addAll({'count': len, 'imagesList': images});
  } else {
    playlistDetails.addEntries([
      MapEntry(playlistName, {'count': len, 'imagesList': images}),
    ]);
  }
  Hive.box('settings').put('playlistDetails', playlistDetails);
}
