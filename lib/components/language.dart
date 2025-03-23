import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Language extends GetxController {
  var isEnglish = true.obs;
  final getStorage = GetStorage();
  final languageKey = 'isEnglish';

  bool isSavedLanguage() {
    return getStorage.read(languageKey) ?? false;
  }

  void saveLanguage(bool isDark) {
    getStorage.write(languageKey, isDark);
    update();
  }

  void changeLang(bool value) {
    isEnglish.value = value;
    saveLanguage(value);
    update();
  }
}
