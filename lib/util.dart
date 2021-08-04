import 'package:url_launcher/url_launcher.dart';

Future<void> openTranslator(String text) async {
  final url =
      "https://translate.google.com/?sl=de&tl=en&text=$text&op=translate";
  launch(url);
}
