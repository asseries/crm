List<int> leftTime(int seconds) {
  int diff = seconds;
  int days = diff ~/ (24 * 60 * 60);
  diff -= days * (24 * 60 * 60);
  int hours = diff ~/ (60 * 60);
  diff -= hours * (60 * 60);
  int minutes = diff ~/ (60);
  diff -= minutes * (60);
  int second = diff % (60);
  List<int> a = [];
  a.add(hours);
  a.add(minutes);
  a.add(second);
  return a;
}

String leftTimeAsTime(int seconds){
  List<int> a = leftTime(seconds);
  return "${a[0]<10?"0${a[0]}":a[0]}:${a[1]<10?"0${a[1]}":a[1]}:${a[2]<10?"0${a[2]}":a[2]}";
}

String leftTimeAsLabel(int seconds){
  List<int> a = leftTime(seconds);
  String time ="";
  if(a[0]!=0) {
    time = a[0]<10?"0${a[0]}":"${a[0]} h";
  }
  if(a[1]!=0){
    time = "$time ${a[1]<10?"0${a[1]}":a[1].toString()} m";
  }
  if(a[2]!=0){
    time = "$time ${a[2]<10?"0${a[2]}":a[2].toString()} s";
  }
  return time;
}
