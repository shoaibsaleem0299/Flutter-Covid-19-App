// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:covid_19_app/constants/app_colors.dart';
import 'package:covid_19_app/widgets/app_button.dart';
import 'package:covid_19_app/widgets/user_input_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    List covidRecored = [];
    final TextEditingController country = TextEditingController();
    Future<void> getCovidRecored() async {
      var url = 'https://api.api-ninjas.com/v1/covid19?country=${country.text}';
      try {
        final response = await http.get(Uri.parse(url),
            headers: {'X-Api-Key': 'CI/RYfNqH7EkdzSRiqbZxQ==bu5YKHvC2WqoGZMm'});
        var responseBody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          // print(responseBody);
          covidRecored.add(responseBody[0]);
          print(covidRecored);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              content: const Center(
                child: Text(
                  "Incorrect contry",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: const Padding(
          padding: EdgeInsets.only(left: 6),
          child: Center(
            child: Text(
              "Covid-19 App",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    child: UserInputField(
                      controller: country,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: AppButton(
                      buttonText: "Get Data",
                      onButtonTap: getCovidRecored,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: covidRecored.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: ListTile(
                        leading: Column(
                          children: [
                            Text(
                              covidRecored.last[index]['country'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              covidRecored[index]['region'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        title: const Text("Deaths"),
                        subtitle: Row(
                          children: [
                            Text(
                              "Total: ${covidRecored[index]['cases']['2020-01-26']['total']}",
                            ),
                            Text(
                              "Total: ${covidRecored[index]['cases']['2020-01-26']['new']}",
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
