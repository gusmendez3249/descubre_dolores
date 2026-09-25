import 'package:flutter/material.dart';
import '../viewmodels/lugares_view_model.dart';
import 'detalle_lugar_screen.dart';

class ListaLugaresScreen extends StatefulWidget {
  final LugaresViewModel viewModel;
  const ListaLugaresScreen({super.key, required this.viewModel});

  @override
  State<ListaLugaresScreen> createState() => _ListaLugaresScreenState();
}

class _ListaLugaresScreenState extends State<ListaLugaresScreen> {
  String _busqueda = '';
  String _filtroActivo = 'todos'; // 'todos', 'audio', 'video'

  @override
  void initState() {
    super.initState();
    widget.viewModel.cargar();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        if (widget.viewModel.cargando) {
          return const Scaffold(
            backgroundColor: Color(0xFF0F1115),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFFD4AF37),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Cargando Guía Turística...',
                    style: TextStyle(
                      color: Color(0xFFE5E7EB),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Filtrar lugares según búsqueda y categoría seleccionada
        final lugaresFiltrados = widget.viewModel.lugares.where((lugar) {
          final coincideBusqueda = lugar.nombre
                  .toLowerCase()
                  .contains(_busqueda.toLowerCase()) ||
              lugar.descripcion.toLowerCase().contains(_busqueda.toLowerCase());

          if (!coincideBusqueda) return false;

          if (_filtroActivo == 'video') {
            return lugar.videoAsset != null;
          } else if (_filtroActivo == 'audio') {
            return lugar.audioAsset.isNotEmpty;
          }
          return true;
        }).toList();

        final totalLugares = widget.viewModel.lugares.length;
        final totalVideos =
            widget.viewModel.lugares.where((l) => l.videoAsset != null).length;

        return Scaffold(
          backgroundColor: const Color(0xFF0F1115),
          appBar: AppBar(
            backgroundColor: const Color(0xFF14171D),
            elevation: 0,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9E3D24), Color(0xFFD4AF37)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_balance_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Descubre Dolores Hidalgo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.5),
              child: Container(
                height: 1.5,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x00D4AF37),
                      Color(0xFFD4AF37),
                      Color(0x00D4AF37)
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
                children: [
                  // Banner Header Luxury Dark Imperial Gradient
                  Container(
                    margin: const EdgeInsets.only(bottom: 22),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7A2E1D),
                          Color(0xFF4A1209),
                          Color(0xFF1F0804),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withOpacity(0.35),
                        width: 1.2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x66000000),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37).withOpacity(0.18),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFD4AF37)
                                      .withOpacity(0.6),
                                  width: 1,
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '🇲🇽 PUEBLO MÁGICO • CUNA DE LA INDEPENDENCIA',
                                    style: TextStyle(
                                      color: Color(0xFFF3E5AB),
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Guía Multimedia Interactiva',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Explora la cuna de la Patria a través de fotografías panorámicas, narraciones históricas en audio HD y recorridos virtuales en video.',
                          style: TextStyle(
                            color: Color(0xFFD1D5DB),
                            fontSize: 14,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            _buildStatBadge(
                              Icons.place_rounded,
                              '$totalLugares Sitios Históricos',
                            ),
                            const SizedBox(width: 10),
                            _buildStatBadge(
                              Icons.headphones_rounded,
                              '$totalLugares Audios HD',
                            ),
                            const SizedBox(width: 10),
                            _buildStatBadge(
                              Icons.videocam_rounded,
                              '$totalVideos Recorrido Video',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Barra de Búsqueda Dark Glass
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF181B22),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF2A2E39),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _busqueda = val),
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Buscar sitio histórico o palabra clave...',
                        hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFFD4AF37),
                          size: 22,
                        ),
                        suffixIcon: _busqueda.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded,
                                    color: Color(0xFF9CA3AF)),
                                onPressed: () {
                                  setState(() => _busqueda = '');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 15),
                      ),
                    ),
                  ),

                  // Chips de Filtro Interactivos
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('todos', 'Todos los sitios', Icons.grid_view_rounded),
                        const SizedBox(width: 10),
                        _buildFilterChip(
                            'audio', 'Con Audio-guía', Icons.headphones_rounded),
                        const SizedBox(width: 10),
                        _buildFilterChip('video', 'Con Recorrido Video', Icons.videocam_rounded),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Estado vacío de búsqueda
                  if (lugaresFiltrados.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(40),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF181B22),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF2A2E39)),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 52, color: Color(0xFF6B7280)),
                          SizedBox(height: 14),
                          Text(
                            'No se encontraron sitios con ese filtro',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE5E7EB),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Intenta con otra palabra clave o selecciona "Todos los sitios"',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...List.generate(lugaresFiltrados.length, (i) {
                      final lugar = lugaresFiltrados[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF181B22),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF2A2E39),
                            width: 1,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 14,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            splashColor: const Color(0xFF9E3D24).withOpacity(0.2),
                            highlightColor:
                                const Color(0xFFD4AF37).withOpacity(0.1),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetalleLugarScreen(lugar: lugar),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  // Imagen Hero con vignette y borde dorado
                                  Hero(
                                    tag: 'lugar-img-${lugar.id}',
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: const Color(0xFF373C4B),
                                          width: 1,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black38,
                                            blurRadius: 8,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15),
                                        child: Image.asset(
                                          lugar.imagenAsset,
                                          width: 110,
                                          height: 110,
                                          fit: BoxFit.cover,
                                          errorBuilder: (ctx, err, stack) =>
                                              Container(
                                            width: 110,
                                            height: 110,
                                            color: const Color(0xFF252A34),
                                            child: const Icon(
                                              Icons.image_not_supported_rounded,
                                              color: Color(0xFF6B7280),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Detalles del lugar
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lugar.nombre,
                                          style: const TextStyle(
                                            fontSize: 16.5,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          lugar.descripcion,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF9CA3AF),
                                            height: 1.4,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            _buildFeatureTag(
                                              Icons.headphones_rounded,
                                              'Audio HD',
                                              const Color(0xFFD4AF37),
                                            ),
                                            if (lugar.videoAsset != null) ...[
                                              const SizedBox(width: 8),
                                              _buildFeatureTag(
                                                Icons.videocam_rounded,
                                                'Video HD',
                                                const Color(0xFFE58E26),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Botón circular de navegación
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF232732),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF373C4B),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14,
                                      color: Color(0xFFD4AF37),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFFD4AF37)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTag(IconData icon, String text, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: accentColor.withOpacity(0.35),
          width: 0.9,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: accentColor),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String clave, String etiqueta, IconData icono) {
    final activo = _filtroActivo == clave;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => setState(() => _filtroActivo = clave),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
          decoration: BoxDecoration(
            gradient: activo
                ? const LinearGradient(
                    colors: [Color(0xFF9E3D24), Color(0xFFB45309)],
                  )
                : null,
            color: activo ? null : const Color(0xFF181B22),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: activo
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFF2A2E39),
              width: 1.2,
            ),
            boxShadow: activo
                ? [
                    BoxShadow(
                      color: const Color(0xFF9E3D24).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icono,
                size: 16,
                color: activo ? Colors.white : const Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 7),
              Text(
                etiqueta,
                style: TextStyle(
                  color: activo ? Colors.white : const Color(0xFFD1D5DB),
                  fontWeight: activo ? FontWeight.bold : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
