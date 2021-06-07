import '../constants.dart';

bool priceValidation(String price) {
  for (int i = 0; i < price.length; i++)
    if (!'.0123456789'.contains(price[i])) return false;
  if (price.indexOf('.') != price.lastIndexOf('.')) return false;
  return true;
}

String filenameValidation(String filename) {
  String error;
  if (filename.isEmpty) {
    error = 'пустая строка';
  } else if (filename
          .split('')
          .where((e) => ConstData.forbiddenFileCharacters.contains(e))
          .length >
      0) {
    error = filename
        .split('')
        .where((e) => ConstData.forbiddenFileCharacters.contains(e))
        .toList()[0];
  } else if (filename.endsWith('.')) {
    error = 'точка в конце';
  } else if (filename.endsWith(' ')) {
    error = 'пробел в конце';
  } else if (filename.endsWith(r'\0')) {
    error = r'\0 в конце';
  }
  return error;
}
