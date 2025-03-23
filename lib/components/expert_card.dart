// ignore_for_file: prefer_const_constructors

import 'package:excon/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExpertCard extends StatelessWidget {
  final String expert_name;
  final double rating;
  final List consultTypes;
  final VoidCallback onPressed;
  final String photo_path;

  ExpertCard({
    required this.expert_name,
    required this.rating,
    required this.onPressed,
    required this.consultTypes,
    required this.photo_path,
  });

  @override
  Widget build(BuildContext context) {
    // print(photo_path);
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(kCornerRoundness),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kCornerRoundness),
        ),
        padding: EdgeInsets.all(10.0),
        height: 100,
        width: 50,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: onPressed,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.network(
                      "$url${photo_path}",
                      height: 64,
                      width: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'images/profile2.png',
                          height: 64,
                          width: 64,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                )

              ),
              Expanded(
                flex: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      expert_name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Jaldi',
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for(int i=0;i<consultTypes.length;i++)...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              mappedConsultTypes[consultTypes[i]],
                              size: 18,
                            ),
                          ),
                        ]
                      ]
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '$rating',
                          style: TextStyle(fontSize: 18, fontFamily: 'Jaldi'),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
