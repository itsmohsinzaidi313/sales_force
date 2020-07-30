import 'dart:convert';

class JsonObject extends Iterable {
  Map<String, String> _map;

  JsonObject() {
    this._map = new Map<String, String>();
  }

  put(
      {String key,
      String value,
      Map<String, dynamic> map,
      JsonObject jsonObject,
      List<JsonObject> jsonObjectList,
      List<Map<String, dynamic>> mapList}) {
    if (key.isEmpty) throw ArgumentError.notNull(key);

    key = jsonEncode(key);
    if (value.isNotEmpty) {
      value = jsonEncode(value);
      this._map[key] = value;
    } else if (jsonObjectList.isNotEmpty) {
      this._map[key] = '$jsonObjectList';
    } else if (mapList.isNotEmpty) {
      this._map[key] = jsonEncode(mapList);
    } else if (map.isNotEmpty) {
      map.forEach((k, v) {
        this._map[jsonEncode(k)] = jsonEncode(v);
      });
    } else if (jsonObject.isNotEmpty){
      this._map[key] = jsonObject.get();
    }
  }

  get() => this._map;

  @override
  Iterator get iterator => null;
}

class JsonArray {
  List<JsonObject> _list;

  JsonArray() {
    this._list = new List();
  }

  add(JsonObject jsonObject) {
    this._list.add(jsonObject);
  }

  getJSONObject() => this._list;
}
