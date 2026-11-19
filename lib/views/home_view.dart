import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/curso.dart';
import 'detail_view.dart';
import 'login_view.dart';

class HomeView extends StatefulWidget {
  final String usuario;

  const HomeView({super.key, required this.usuario});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _busqueda = '';
  Set<String> _cursosInscritos = {};

  @override
  void initState() {
    super.initState();
    _cargarInscritos();
  }

  Future<void> _cargarInscritos() async {
    final prefs = await SharedPreferences.getInstance();
    final guardados = prefs.getStringList('cursos_inscritos') ?? [];
    setState(() {
      _cursosInscritos = guardados.toSet();
    });
  }

  void _cerrarSesion() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cursosFiltrados = cursosDemo
        .where(
          (curso) =>
              curso.nombre.toLowerCase().contains(_busqueda.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cursos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: _cerrarSesion,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Bienvenido, ${widget.usuario}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar curso por nombre',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (valor) {
                setState(() {
                  _busqueda = valor;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cursosFiltrados.length,
              itemBuilder: (context, index) {
                final curso = cursosFiltrados[index];
                final estaInscrito = _cursosInscritos.contains(curso.nombre);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: estaInscrito
                          ? Colors.green.shade100
                          : null,
                      child: Icon(
                        estaInscrito ? Icons.check_circle : Icons.book,
                        color: estaInscrito ? Colors.green : null,
                      ),
                    ),
                    title: Text(curso.nombre),
                    subtitle: Text(
                      estaInscrito
                          ? '${curso.instructor} • ${curso.horas} h • Inscrito'
                          : '${curso.instructor} • ${curso.horas} h',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailView(curso: curso),
                        ),
                      );
                      _cargarInscritos();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
