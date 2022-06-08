import "package:flutter/material.dart";
import 'package:currency_picker/currency_picker.dart';

import 'appBar.dart';

Currency nullCurrency = Currency(
  code: "XXX",
  name: "Select a currency",
  symbol: "?",
  flag: null,
  decimalDigits: 2,
  number: 137,
  namePlural: "Select a currency",
  thousandsSeparator: ",",
  decimalSeparator: ".",
  spaceBetweenAmountAndSymbol: false,
  symbolOnLeft: true,
);

Widget myCard({
  Widget contents = const Text("Unable to load contents of the Card!"),
  required double deviceHeight,
  required double deviceWidth,
}) {
  return Container(
    height: deviceHeight / 3,
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.all(20),
    width: deviceWidth,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          blurRadius: 15,
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurStyle: BlurStyle.normal,
        ),
      ],
      borderRadius: BorderRadius.circular(30),
    ),
    child: contents,
  );
}

class CurrencyConvertorPage extends StatefulWidget {
  const CurrencyConvertorPage({Key? key, required this.title})
      : super(key: key);
  final String title;
  @override
  State<CurrencyConvertorPage> createState() => _CurrencyConvertorPageState();
}

class _CurrencyConvertorPageState extends State<CurrencyConvertorPage> {
  Currency fromCurrency = nullCurrency;
  Currency toCurrency = nullCurrency;
  double fromCurrencyValue = 0;
  double toCurrencyValue = 0;
  double conversionValue = 100;

  void swapCurr() => setState(() {
        Currency temp = toCurrency;
        toCurrency = fromCurrency;
        fromCurrency = temp;
        conversionValue = 1 / conversionValue;
      });

  Widget updateCurr(String choice) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(30),
      ),
      onPressed: () {
        showCurrencyPicker(
          context: context,
          showFlag: true,
          showSearchField: true,
          showCurrencyName: true,
          showCurrencyCode: true,
          onSelect: (Currency currency) {
            setState(() {
              if (choice == "source") {
                fromCurrency = currency;
              } else if (choice == "destination") {
                toCurrency = currency;
              }
            });
          },
          favorite: ['INR', 'EUR', 'USD', 'GBP'],
        );
      },
      child: const Text("Choose!"),
    );
  }

  Widget enterCurr(String choice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          choice == "source" ? fromCurrency.symbol : toCurrency.symbol,
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 50,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (number) {
              if (choice == "source") {
                setState(() {
                  fromCurrencyValue = double.parse(number);
                  toCurrencyValue = fromCurrencyValue * conversionValue;
                  print("FROM : $fromCurrencyValue");
                  print("TO : $toCurrencyValue");
                });
              } else if (choice == "destination") {
                setState(() {
                  toCurrencyValue = double.parse(number);
                  fromCurrencyValue = toCurrencyValue / conversionValue;
                  print("FROM : $fromCurrencyValue");
                  print("TO : $toCurrencyValue");
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget displayFlag(Currency currentCurr) {
    return currentCurr.flag == null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              "https://media.istockphoto.com/vectors/white-flag-isolated-symbol-of-defeat-vector-illustration-vector-id854509618?k=20&m=854509618&s=612x612&w=0&h=wmdFuuQY-J48FG8m5f57t1M0HTb3HzX5qeig4DTSRTI=",
              height: 30,
              width: 30,
              fit: BoxFit.contain,
            ),
          )
        : Text(
            CurrencyUtils.currencyToEmoji(currentCurr),
            style: const TextStyle(
              fontSize: 25,
            ),
          );
  }

  Widget printCurr(String choice) {
    Currency currentCurr = nullCurrency;
    if (choice == "source") {
      currentCurr = fromCurrency;
    } else if (choice == "destination") {
      currentCurr = toCurrency;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        displayFlag(currentCurr),
        const SizedBox(width: 10),
        Text(currentCurr.code),
        const SizedBox(width: 10),
        Text(currentCurr.name),
      ],
    );
  }

  Widget currentCurrencyRow(String choice) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            printCurr(choice),
            updateCurr(choice),
          ],
        ),
        enterCurr(choice),
      ],
    );
  }

  Widget inputCard() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          currentCurrencyRow("source"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                tooltip: "Convert",
                icon: const Icon(Icons.arrow_downward_rounded, size: 30),
              ),
              IconButton(
                onPressed: swapCurr,
                tooltip: "Swap Currencies",
                icon: const Icon(Icons.swap_vertical_circle_outlined, size: 30),
              ),
            ],
          ),
          currentCurrencyRow("destination"),
        ],
      ),
    );
  }

  Widget resultCard() {
    return const Text("Hi!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const customSliver(
            appBarTitle: "CURRENCY CONVERTOR",
            appBarBG:
                "https://images.unsplash.com/photo-1599690925058-90e1a0b56154?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1965&q=80",
          ),
        ],
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              myCard(
                contents: inputCard(),
                deviceHeight: MediaQuery.of(context).size.height,
                deviceWidth: MediaQuery.of(context).size.width,
              ),
              myCard(
                contents: resultCard(),
                deviceHeight: MediaQuery.of(context).size.height,
                deviceWidth: MediaQuery.of(context).size.width,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          child: const Text("Convert!"),
          onPressed: () {},
        ),
      ),
    );
  }
}
