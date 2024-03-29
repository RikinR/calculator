import 'package:calculator/pages/history_page.dart';
import 'package:calculator/utils/buttons/text_button.dart';
import 'package:calculator/utils/buttons/text_button_labels.dart';
import 'package:calculator/utils/history_list.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var displayText = '';

  void addToHistory() {
    var condition =
        historyList.isEmpty || historyList.last.toString() != displayText;
    if (condition && !displayText.contains('ERROR!')) {
      historyList.add(displayText);
    }
  }

  void interpretAnswer() {
    try {
      if (displayText.contains('/')) {
        var answer = displayText.interpret().toDouble().toStringAsFixed(11);
        if (answer.contains('.000')) {
          displayText =
              displayText.interpret().truncateToDouble().toStringAsFixed(0);
          return;
        } else {
          displayText = answer;

          return;
        }
      } else if (displayText.contains('.')) {
        displayText = displayText.interpret().toDouble().toStringAsFixed(3);
        return;
      }
      displayText =
          displayText.interpret().truncateToDouble().toStringAsFixed(0);
    } catch (e) {
      displayText = 'ERROR!';
    }
  }

  void onPressing(String label) {
    if (label == 'C') {
      setState(() {
        displayText = '';
      });
      return;
    } else if (label == 'H') {
      return;
    } else if (label == 'e') {
      return;
    } else if (label == 'X') {
      setState(() {
        displayText = displayText + ('*');
      });

      return;
    } else if (label == '(') {
      if (displayText.endsWith(')')) {
        setState(() {
          displayText = displayText + ('*(');
        });
        return;
      }
      setState(() {
        displayText = displayText + ('(');
      });
      return;
    } else if (label == '=') {
      if (displayText.isNotEmpty) {
        addToHistory();

        setState(() {
          interpretAnswer();
        });
      }
    } else {
      setState(() {
        displayText = displayText + label;
      });
    }
  }

  void onTapHistoryItem(index) {
    setState(() {
      displayText = historyList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: (screenHeight * 0.3) -
                  1, //-1 for divider if not -1 then screen overflow
              color: Colors.black,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        displayText,
                        style: const TextStyle(fontSize: 36),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(
                height: 1,
                thickness: 1.5,
                color: Color.fromARGB(255, 44, 44, 44)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.black,
              height: screenHeight * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 24),
                        child: IconButton(
                            onPressed: () {
                              showBottomSheet(
                                backgroundColor:
                                    const Color.fromARGB(255, 3, 3, 3),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20))),
                                context: context,
                                builder: (context) =>
                                    History(onTap: onTapHistoryItem),
                              );
                            },
                            icon: const Icon(
                              Icons.history,
                              size: 30,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, top: 24),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                displayText = displayText.substring(
                                    0, displayText.length - 1);
                              });
                            },
                            icon: const Icon(
                              Icons.backspace,
                              size: 30,
                            )),
                      ),
                    ],
                  ),
                  Expanded(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: buttonLabels.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4),
                      itemBuilder: (context, index) => CustomTextButton(
                          label: buttonLabels[index],
                          onpressed: () {
                            onPressing(buttonLabels[index]);
                          }),
                    ),
                  ),
                ],
              ),
            )
          ]),
    );
  }
}
