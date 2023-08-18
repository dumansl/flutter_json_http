import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_json_http/model/car_model.dart';

class LocalJson extends StatefulWidget {
  const LocalJson({Key? key}) : super(key: key);

  @override
  State<LocalJson> createState() => _LocalJsonState();
}

class _LocalJsonState extends State<LocalJson> {
  String _title = "Local Json İşlemleri";
  late final Future<List<Car>> _fillList;

  @override
  void initState() {
    super.initState();
    _fillList = carsJsonRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _title = "Button tıklanıldı.";
          });
        },
      ),
      body: FutureBuilder<List<Car>>(
        future: _fillList,
        initialData: [
          Car(
            carName: "carName",
            country: "country",
            foundationYear: 1988,
            model: [
              Model(
                modelName: "modelName",
                price: 52,
                gasoline: true,
              ),
            ],
          ),
        ],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Car> carList = snapshot.data!;
            return ListView.builder(
              itemCount: carList.length,
              itemBuilder: (context, index) {
                var currentCar = carList[index];
                return ListTile(
                  title: Text(
                    currentCar.carName,
                  ),
                  subtitle: Text(
                    currentCar.country,
                  ),
                  leading: CircleAvatar(
                      child: Text(currentCar.model[0].price.toString())),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<List<Car>> carsJsonRead() async {
    try {
      debugPrint("5 saniyelik işlem başlıyor");
      await Future.delayed(const Duration(seconds: 5), () {
        debugPrint("5 saniyelik işlem bitti");
      });
      String readString = await DefaultAssetBundle.of(context)
          .loadString("assets/data/cars.json");
      var jsonObject = jsonDecode(readString);
      // debugPrint(readString);
      // debugPrint("*****************************");
      // List carList = jsonObject;
      // debugPrint(carList[1]["model"][0]["price"].toString());

      List<Car> allCars =
          (jsonObject as List).map((carMap) => Car.fromMap(carMap)).toList();

      return allCars;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e.toString());
    }
  }
}
