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
    const primaryColor = Color(0xFF7A2E1D); // Terracota Colonial
    const secondaryColor = Color(0xFFD97706); // Ámbar dorado

    return MaterialApp(
      title: 'Descubre Dolores Hidalgo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
          surface: const Color(0xFFFCFBF9),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F4EF),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 3,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: ListaLugaresScreen(viewModel: viewModel),
    );
  }
}
