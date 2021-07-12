import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  setStorage(key, value, {type}) async{
    final SharedPreferences prefs = await _prefs;
    switch(type) {
      case 'bool':
        await prefs.setBool(key, value);
        break;
      case 'int':
        await prefs.setInt(key, value);
        break;
      case 'double':
        await prefs.setDouble(key, value);
        break;
      case 'list':
        await prefs.setStringList(key, value);
        break;
      default:
        await prefs.setString(key, value);
        break;
    }
  }

  getStorage(key) async{
    final SharedPreferences prefs = await _prefs;
    return prefs.get(key);
  }

  removeStorage(key) async{
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(key);
  }

  clearStorage() async{
    final SharedPreferences prefs = await _prefs;
    await prefs.clear();
  }

  setSearchHistory(value) async {
    List<String> searchList = await this.getStorage('searchList');
    if (searchList == null) {
      searchList = [];
    }
    searchList.remove(value);
    searchList.insert(0,value);
    await this.setStorage('searchList', searchList, type: 'list');
  }
}
