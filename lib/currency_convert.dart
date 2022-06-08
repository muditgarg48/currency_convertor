import "package:flutter/material.dart";
// ignore: depend_on_referenced_packages
import 'package:currency_picker/currency_picker.dart' as pick;
import 'package:frankfurter/frankfurter.dart' as convert;

import 'appBar.dart';

pick.Currency nullCurrency = pick.Currency(
  code: "XXX",
  name: "Select a currency",
  symbol: "(_)",
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
  const CurrencyConvertorPage({Key? key}) : super(key: key);
  @override
  State<CurrencyConvertorPage> createState() => _CurrencyConvertorPageState();
}

class _CurrencyConvertorPageState extends State<CurrencyConvertorPage> {
  pick.Currency fromCurrency = nullCurrency;
  pick.Currency toCurrency = nullCurrency;
  double fromCurrencyValue = 0;
  double toCurrencyValue = 0;
  double conversionValue = 1;
  // ignore: prefer_typing_uninitialized_variables
  var latestForexRates;
  var controller = TextEditingController();

  void nullify(String choice) => setState(() {
        if (choice == "whole") {
          fromCurrency = nullCurrency;
          toCurrency = nullCurrency;
          latestForexRates = null;
          conversionValue = 1;
        }
        fromCurrencyValue = 0;
        toCurrencyValue = 0;
        controller.clear();
      });

  void genParticularForexRate() async {
    final frankfurter = convert.Frankfurter();
    final conversion = await frankfurter.getRate(
      from: convert.Currency(fromCurrency.code),
      to: convert.Currency(toCurrency.code),
    );
    setState(() => conversionValue = conversion.rate);
    // print('Single conversion: $conversion');
  }

  void genAllForexRate() async {
    final frankfurter = convert.Frankfurter();
    latestForexRates =
        await frankfurter.latest(from: convert.Currency(fromCurrency.code));
  }

  void swapCurr() {
    setState(() {
      pick.Currency temp = toCurrency;
      toCurrency = fromCurrency;
      fromCurrency = temp;
      conversionValue = 1 / conversionValue;
      double tempValue = toCurrencyValue;
      toCurrencyValue = fromCurrencyValue;
      fromCurrencyValue = tempValue;
      controller.clear();
    });
  }

  Widget updateCurr(String choice) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(30),
      ),
      onPressed: () {
        pick.showCurrencyPicker(
          context: context,
          showFlag: true,
          showSearchField: true,
          showCurrencyName: true,
          showCurrencyCode: true,
          onSelect: (pick.Currency currency) {
            setState(() {
              if (choice == "source") {
                fromCurrency = currency;
                genAllForexRate();
              } else if (choice == "destination") {
                toCurrency = currency;
                genParticularForexRate();
              }
            });
          },
          favorite: ['INR', 'EUR', 'USD', 'GBP'],
        );
      },
      child: const Text("Choose"),
    );
  }

  Widget enterCurr(String choice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          choice == "source" ? fromCurrency.symbol : toCurrency.symbol,
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 50,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: choice == "source"
              ? TextField(
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (number) {
                    setState(() {
                      fromCurrencyValue = double.parse(number);
                      toCurrencyValue = fromCurrencyValue * conversionValue;
                      // print("FROM : $fromCurrencyValue");
                      // print("TO : $toCurrencyValue");
                    });
                  },
                )
              : Text(
                  "$toCurrencyValue",
                  style: Theme.of(context).textTheme.headline6,
                ),
        ),
      ],
    );
  }

  Widget displayFlag(pick.Currency currentCurr) {
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
            pick.CurrencyUtils.currencyToEmoji(currentCurr),
            style: const TextStyle(
              fontSize: 25,
            ),
          );
  }

  Widget printCurr(String choice) {
    pick.Currency currentCurr = nullCurrency;
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

  Widget inputCardContents() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          currentCurrencyRow("source"),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => nullify("values"),
                tooltip: "Reset values only",
                icon: const Icon(
                  Icons.clear_rounded,
                  size: 25,
                ),
              ),
              IconButton(
                onPressed: swapCurr,
                tooltip: "Swap Currencies",
                icon: const Icon(
                  Icons.swap_calls_outlined,
                  size: 25,
                ),
              ),
              IconButton(
                onPressed: () => nullify("whole"),
                tooltip: "Reset completly",
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 25,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          currentCurrencyRow("destination"),
        ],
      ),
    );
  }

  Widget moreDetailsCardContents() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("${fromCurrency.name} (${fromCurrency.code})"),
            const Icon(Icons.arrow_drop_down_rounded),
            Text("${toCurrency.name} (${fromCurrency.code})"),
            Text(
                "LIVE Forex is: ${fromCurrency.symbol}1 = ${toCurrency.symbol}$conversionValue"),
          ],
        ),
      ),
    );
  }

  Widget forexRateSheet() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Text(
              "Current Forex Rate Sheet of ${fromCurrency.code}",
              style: Theme.of(context).textTheme.headline6,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 2,
            indent: 15,
            endIndent: 15,
          ),
          for (convert.Rate r in latestForexRates)
            Container(
              padding: const EdgeInsets.all(3),
              child: Column(
                children: [
                  Text(
                    "1 ${r.from} = ${r.rate} ${r.to}",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          TextButton(
            child: const Text('Close Forex Rate Sheet'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
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
                contents: inputCardContents(),
                deviceHeight: MediaQuery.of(context).size.height,
                deviceWidth: MediaQuery.of(context).size.width,
              ),
              myCard(
                contents: moreDetailsCardContents(),
                deviceHeight: MediaQuery.of(context).size.height / 2,
                deviceWidth: MediaQuery.of(context).size.width,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        child: const Text("View all Forex Rates"),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height / 1.5,
                color: Colors.amber,
                child: forexRateSheet(),
              );
            },
          );
        },
      ),
    );
  }
}
