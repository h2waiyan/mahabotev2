import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedDate = DateTime.now();
  var selected = false;
  var f = DateFormat("dd/MM/yyyy EEEE");

  var modVal = 0;
  var houseName = "";

  var isNewYearBorn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('မဟာဘုတ်'),
        elevation: 0,
      ),
      body: _homeDesign(),
    );
  }

  String _houseResult(year, day) {
    var houses = ["ဘင်္ဂ", "အထွန်း", "ရာဇ", "အဓိပတိ", "မရဏ", "သိုက်", "ပုတိ"];
    return houses[(year - day - 1) % 7];
  }

  var myanmarHouses = [
    "ဘင်္ဂ",
    "မရဏ",
    "အထွန်း",
    "သိုက်",
    "ရာဇ",
    "ပုတိ",
    "အဓိပတိ"
  ];

  List<dynamic> rotatedHouse = [
    "ဘင်္ဂ",
    "မရဏ",
    "အထွန်း",
    "သိုက်",
    "ရာဇ",
    "ပုတိ",
    "အဓိပတိ"
  ];

  List newChart(String name) {
    // var houses = ["1", "4", "0", "3", "6", "2", "5"];
    var startIndex = myanmarHouses.indexOf(name);

    if (startIndex == 0) {
      return myanmarHouses;
    } else {
      var newHouse = myanmarHouses.sublist(startIndex, myanmarHouses.length) +
          myanmarHouses.sublist(0, startIndex);

      return newHouse;
    }
  }

  TextStyle selectedColor(val) => TextStyle(
      color: houseName == val ? Theme.of(context).primaryColor : Colors.black);

  Text _label_text(val) => Text(val, style: (selectedColor(val)));
  Container chartBox(val) => Container(
      decoration: BoxDecoration(border: Border.all(width: 1)),
      height: 50,
      width: 75,
      child: Center(child: _label_text(val)));

  Widget _mahabote_layout(val) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                chartBox(" "),
                chartBox(val[6]),
                chartBox(" "),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                chartBox(val[2]),
                chartBox(val[3]),
                chartBox(val[4]),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                chartBox(val[1]),
                chartBox(val[0]),
                chartBox(val[5]),
              ],
            ),
          ],
        ),
      );

  Widget _homeDesign() => ListView(
        children: <Widget>[
          Container(
            height: 120,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1800),
                          lastDate: DateTime(2050),
                          helpText: "Select your birthday",
                          cancelText: "Not Now",
                        );
                        if (picked != null) {
                          int myanmarYear;

                          setState(() {
                            var myanmarYear = picked.year - 638;

                            if (picked.month < 4 ||
                                picked.month == 4 && isNewYearBorn == false) {
                              myanmarYear = picked.year - 639;
                            }

                            selectedDate = picked;
                            modVal = myanmarYear % 7;
                            houseName =
                                _houseResult(myanmarYear, picked.weekday);
                            selected = true;

                            rotatedHouse = newChart(houseName);
                            debugPrint(myanmarYear.toString());
                          });
                        }
                      },
                      child: selected
                          ? Text(f.format(selectedDate))
                          : const Text("Select Your Birthday")),
                  selectedDate.month == 4
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              value: isNewYearBorn,
                              onChanged: (bool? value) {
                                setState(() {
                                  isNewYearBorn = value!;

                                  var myanmarYear = selectedDate.year - 638;

                                  if (selectedDate.month < 4 ||
                                      selectedDate.month == 4 &&
                                          isNewYearBorn == false) {
                                    myanmarYear = selectedDate.year - 639;
                                  }

                                  selectedDate = selectedDate;
                                  modVal = myanmarYear % 7;
                                  houseName = _houseResult(
                                      myanmarYear, selectedDate.weekday);
                                  selected = true;

                                  rotatedHouse = newChart(houseName);
                                  // debugPrint(myanmarYear.toString());
                                  // debugPrint(isNewYearBorn.toString());
                                });
                              },
                            ),
                            const Text("မြန်မာနှစ်သစ်ကူးပြီးမှ မွေးသူဖြစ်ပါသည်")
                          ],
                        )
                      : Row(),
                ],
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.all(12),
              height: 220,
              child: Card(
                child: Center(
                  child: _mahabote_layout(myanmarHouses),
                ),
              )),
          selected
              ? Container(
                  margin: const EdgeInsets.all(12),
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        Text("အကြွင်း $modVal ရပါသည်။"),
                        Text("သင်သည် $houseName ဖွားဖြစ်သည်")
                      ],
                    ),
                  )),
                )
              : Container(),
          selected
              ? Container(
                  margin: const EdgeInsets.all(12),
                  height: 220,
                  child: Card(
                    child: Center(
                      child: _mahabote_layout(rotatedHouse),
                    ),
                  ))
              : Container()
        ],
      );
}
