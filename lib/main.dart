import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const TableroFutsal(),
    );
  }
}

class TableroFutsal extends StatefulWidget {
  const TableroFutsal({super.key});
  @override
  State<TableroFutsal> createState() => _TableroFutsalState();
}

class _TableroFutsalState extends State<TableroFutsal> {
  int golesLocal = 0, golesVisitante = 0;
  int faltasLocal = 0, faltasVisitante = 0;
  int periodo = 1;

  Timer? _timer;
  int _segundosRestantes = 1200; 
  bool _estaCorriendo = false;

  void _iniciarOPausar() {
    if (_estaCorriendo) {
      _timer?.cancel();
      setState(() => _estaCorriendo = false);
    } else {
      _estaCorriendo = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_segundosRestantes > 0) {
            _segundosRestantes--;
          } else {
            _timer?.cancel();
            _estaCorriendo = false;
          }
        });
      });
    }
  }

  void _reiniciarTiempo() {
    _timer?.cancel();
    setState(() {
      _segundosRestantes = 1200;
      _estaCorriendo = false;
    });
  }

  String _formatearTiempo() {
    int minutos = _segundosRestantes ~/ 60;
    int segundos = _segundosRestantes % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text("PERIODO $periodo", style: const TextStyle(fontSize: 24, color: Colors.amber)),
                GestureDetector(
                  onTap: _iniciarOPausar,
                  child: Text(
                    _formatearTiempo(),
                    style: const TextStyle(fontSize: 90, fontWeight: FontWeight.bold, fontFamily: 'Courier'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: const Icon(Icons.refresh), onPressed: _reiniciarTiempo),
                    Text(_estaCorriendo ? "PAUSAR" : "INICIAR", style: const TextStyle(color: Colors.grey)),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _bloqueEquipo("LOCAL", golesLocal, faltasLocal, (g) => setState(() => golesLocal += g), (f) => setState(() => faltasLocal += f)),
                _bloqueEquipo("VISITANTE", golesVisitante, faltasVisitante, (g) => setState(() => golesVisitante += g), (f) => setState(() => faltasVisitante += f)),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  golesLocal = 0; golesVisitante = 0;
                  faltasLocal = 0; faltasVisitante = 0;
                  periodo = 1; _reiniciarTiempo();
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              child: const Text("Reiniciar Partido"),
            )
          ],
        ),
      ),
    );
  }

  Widget _bloqueEquipo(String nombre, int goles, int faltas, Function(int) cambGoles, Function(int) cambFaltas) {
    return Column(
      children: [
        Text(nombre, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        Row(
          children: [
            IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => goles > 0 ? cambGoles(-1) : null),
            Text('$goles', style: const TextStyle(fontSize: 60)),
            IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => cambGoles(1)),
          ],
        ),
        Text("FALTAS: $faltas", style: TextStyle(color: faltas >= 5 ? Colors.red : Colors.white70)),
        Row(
          children: [
            IconButton(icon: const Icon(Icons.exposure_minus_1), onPressed: () => faltas > 0 ? cambFaltas(-1) : null),
            IconButton(icon: const Icon(Icons.plus_one, color: Colors.amber), onPressed: () => cambFaltas(1)),
          ],
        ),
      ],
    );
  }
}
