import 'package:fe_sektak/api_callers/review_api.dart';
import 'package:fe_sektak/models/ride.dart';
import 'package:flutter/material.dart';

import 'main_screen.dart';

class ReviewScreen extends StatefulWidget {
  static const id = 'Review_Screen';
  final Ride ride;
  final String driverId;
  const ReviewScreen({Key key, this.ride, this.driverId}) : super(key: key);
  @override
  _ReviewScreenState createState() =>
      _ReviewScreenState(this.ride, this.driverId);
}

class _ReviewScreenState extends State<ReviewScreen> {
  final Ride ride;
  final String driverId;
  List<int> rates = new List<int>();
  int step = 0;
  _ReviewScreenState(this.ride, this.driverId);

  @override
  void initState() {
    super.initState();
    driverId == null ? initList() : rates.add(0);
  }

  void initList() {
    for (int index = 0; index < ride.requests.length; index++) {
      rates.add(0);
    }
  }

  List<int> availableRates = <int>[0, 1, 2, 3, 4];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Page'),
      ),
      body: driverId == null
          ? Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: SingleChildScrollView(
                  child: Stepper(
                      onStepContinue: () async {
                        ReviewApi apiCaller = new ReviewApi();
                        String status = await apiCaller.create(userData: {
                          'userId': ride.requests.elementAt(step).passenger.id,
                          'rate': rates[step]
                        });
                        if (status == 'done') {
                          setState(() {
                            if (step + 1 >= ride.requests.length) {
                              Navigator.popAndPushNamed(context, MainPage.id);
                            } else {
                              step++;
                            }
                          });
                        }
                      },
                      currentStep: step,
                      steps: [
                    for (int index = 0; index < ride.requests.length; index++)
                      Step(
                          title: Text('Passenger Name : ' +
                              ride.requests.elementAt(index).passenger.name),
                          subtitle: Text(
                              'His Total Review Before Ride \n ${ride.requests.elementAt(index).passenger.totalReview.toStringAsFixed(2)}'),
                          content: Container(
                              child: DropdownButton<int>(
                            hint: Text("Select rate"),
                            value: rates[index],
                            onChanged: (int value) {
                              setState(() {
                                rates[index] = value;
                              });
                            },
                            items:
                                List.generate(availableRates.length, (index) {
                              return DropdownMenuItem<int>(
                                  value: availableRates[index],
                                  child: Row(
                                    children: <Widget>[
                                      Text('Rate: '),
                                      Text(
                                        availableRates[index].toString(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ));
                            }),
                          )))
                  ])))
          : Container(
              color: Colors.blue,
              child: Stepper(
                  onStepContinue: () async {
                    ReviewApi apiCaller = new ReviewApi();
                    String status = await apiCaller.create(
                        userData: {'userId': driverId, 'rate': rates[step]});
                    if (status == 'done') {
                      setState(() {
                        Navigator.popAndPushNamed(context, MainPage.id);
                      });
                    }
                  },
                  currentStep: step,
                  steps: [
                    for (int index = 0; index < 1; index++)
                      Step(
                          content: Container(
                              child: DropdownButton<int>(
                            hint: Text("Select rate"),
                            value: rates[index],
                            onChanged: (int value) {
                              setState(() {
                                rates[index] = value;
                              });
                            },
                            items:
                                List.generate(availableRates.length, (index) {
                              return DropdownMenuItem<int>(
                                  value: availableRates[index],
                                  child: Row(
                                    children: <Widget>[
                                      Text('Rate: '),
                                      Text(
                                        availableRates[index].toString(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ));
                            }),
                          )),
                          title: Text(''))
                  ])),
    );
  }
}
