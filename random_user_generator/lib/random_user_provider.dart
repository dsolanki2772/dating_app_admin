import 'package:random_user_generator/random_user_model.dart';
import 'package:http/http.dart' as http;

Future<RandomUserModel?> getRandomUsers() async {
  final Uri url = Uri.parse('https://randomuser.me/api/?results=200');

  print("Getting data...");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return randomUserModelFromJson(response.body);
  } else {
    print(response);
    return null;
  }
}
