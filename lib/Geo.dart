import 'package:flutter/material.dart';

class Geo {

  final String description;
  final double temp;

  const Geo({
    required this.description,
    required this.temp,

  });

  factory Geo.fromJson(Map<String, dynamic> json) {
    return switch(json) {
      {
        'weather': [
          {
            'description': String description
          },
        ],
        'main': {
          'temp': double temp
        }
      } => Geo(
        description: description,
        temp: temp
      ),

      _ => throw const FormatException('Failed to map') 
    };
  }

}