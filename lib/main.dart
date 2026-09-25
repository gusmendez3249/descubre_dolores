import 'package:flutter/material.dart';
import 'data/datasources/lugares_local_datasource.dart';
import 'data/repositories/lugares_repository_impl.dart';
import 'domain/usecases/obtener_lugares.dart';
import 'presentation/viewmodels/lugares_view_model.dart';
import 'presentation/views/lista_lugares_screen.dart';

void main() {
  // Composicion manual de dependencias: aqui, y solo aqui,
  // se conocen las clases concretas de las 3 capas.
  final dataSource = LugaresLocalDataSource();
  final repository = LugaresRepositoryImpl(dataSource);
  final obtenerLugares = ObtenerLugares(repository);
  final viewModel = LugaresViewModel(obtenerLugares);

  runApp(DescubreDoloresApp(viewModel: viewModel));
}

class DescubreDoloresApp extends StatelessWidget {
  final LugaresViewModel viewModel;
  const DescubreDoloresApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF9E3D24); // Terracota Imperial
    const goldAccent = Color(0xFFD4AF37); // Oro Colonial
    const darkBackground = Color(0xFF0F1115); // Obsidian Dark
    const cardBackground = Color(0xFF181B22); // Dark Glass Surface

    return MaterialApp(
      title: 'Descubre Dolores Hidalgo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: primaryColor,
          secondary: goldAccent,
          surface: cardBackground,
          background: darkBackground,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Color(0xFFF3F4F6),
        ),
        scaffoldBackgroundColor: darkBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF14171D),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          color: cardBackground,
          elevation: 6,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF2A2E39), width: 1),
          ),
        ),
      ),
      home: ListaLugaresScreen(viewModel: viewModel),
    );
  }
}
