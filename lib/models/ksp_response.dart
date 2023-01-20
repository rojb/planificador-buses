import 'dart:convert';

import 'package:planificador_buses/models/models.dart';

class KspResponse {
  KspResponse({
    required this.totalCost,
    required this.edges,
  });

  final double? totalCost;
  final List<Edge?>? edges;

  factory KspResponse.fromJson(String str) =>
      KspResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory KspResponse.fromMap(Map<String, dynamic> json) => KspResponse(
        totalCost: json["totalCost"].toDouble(),
        edges: json["edges"] == null
            ? []
            : List<Edge?>.from(json["edges"]!.map((x) => Edge.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "totalCost": totalCost,
        "edges": edges == null
            ? []
            : List<dynamic>.from(edges!.map((x) => x!.toMap())),
      };
}

class Edge {
  Edge({
    required this.fromNode,
    required this.paradaIni,
    required this.toNode,
    required this.paradaSig,
    required this.weight,
  });

  final String fromNode;
  final Parada paradaIni;
  final String toNode;
  final Parada paradaSig;
  final double weight;

  factory Edge.fromJson(String str) => Edge.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Edge.fromMap(Map<String, dynamic> json) => Edge(
        fromNode: json["fromNode"],
        paradaIni: Parada.fromMap(json["paradaIni"]),
        toNode: json["toNode"],
        paradaSig: Parada.fromMap(json["paradaSig"]),
        weight: json["weight"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "fromNode": fromNode,
        "paradaIni": paradaIni.toMap(),
        "toNode": toNode,
        "paradaSig": paradaSig.toMap(),
        "weight": weight,
      };
}

class LineaCode {
  LineaCode({
    required this.lineaCod,
    required this.tipo,
  });

  final String lineaCod;
  final String tipo;

  factory LineaCode.fromJson(String str) => LineaCode.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LineaCode.fromMap(Map<String, dynamic> json) => LineaCode(
        lineaCod: json["lineaCod"],
        tipo: json["tipo"],
      );

  Map<String, dynamic> toMap() => {
        "lineaCod": lineaCod,
        "tipo": tipo,
      };
}
