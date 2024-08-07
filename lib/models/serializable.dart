
import 'dart:convert';

abstract class Serializable {

  String serialize() {
    return json.encode(this.toMap());
  }

  void deserialize(String text) {
    this.fromMap(json.decode(text));
  }

  //abstract
  Map<String, dynamic> toMap();

  //abstract
  void fromMap(Map<String, dynamic> map);
}