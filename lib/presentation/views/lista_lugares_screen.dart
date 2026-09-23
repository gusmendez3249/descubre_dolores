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
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Color(0xFF7A2E1D)),
                  SizedBox(height: 16),
                  Text(
                    'Cargando la guía turística...',
                    style: TextStyle(
                      color: Color(0xFF7A2E1D),
                      fontWeight: FontWeight.w600,
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
          appBar: AppBar(
            elevation: 0,
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.account_balance_rounded, size: 24),
                SizedBox(width: 10),
                Text(
                  'Descubre Dolores Hidalgo',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                children: [
                  // Banner Header con Gradiente Colonial HD
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7A2E1D),
                          Color(0xFF9E3D24),
                          Color(0xFFB45309),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x337A2E1D),
                          blurRadius: 16,
                          offset: Offset(0, 6),
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
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '🇲🇽 CUNA DE LA INDEPENDENCIA',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Guía Multimedia Interactiva',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Recorre los monumentos más representativos con fotografías de alta definición, narraciones en audio-guía y recorridos en video.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildStatBadge(
                                Icons.place, '$totalLugares Sitios'),
                            const SizedBox(width: 10),
                            _buildStatBadge(
                                Icons.headphones, '$totalLugares Audios'),
                            const SizedBox(width: 10),
                            _buildStatBadge(
                                Icons.videocam, '$totalVideos Video'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Barra de Búsqueda
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _busqueda = val),
                      decoration: InputDecoration(
                        hintText: 'Buscar por sitio o palabra clave...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        prefixIcon: const Icon(Icons.search,
                            color: Color(0xFF7A2E1D)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),

                  // Chips de Filtro
                  Row(
                    children: [
                      _buildFilterChip('todos', 'Todos los sitios', Icons.apps),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'audio', 'Con Audio-guía', Icons.headphones),
                      const SizedBox(width: 8),
                      _buildFilterChip('video', 'Con Video', Icons.videocam),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (lugaresFiltrados.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            'No se encontraron lugares turísticos',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...List.generate(lugaresFiltrados.length, (i) {
                      final lugar = lugaresFiltrados[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetalleLugarScreen(lugar: lugar),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Hero(
                                    tag: 'lugar-img-${lugar.id}',
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.asset(
                                        lugar.imagenAsset,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (ctx, err, stack) =>
                                            Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey.shade300,
                                          child: const Icon(Icons.image,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lugar.nombre,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          lugar.descripcion,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade700,
                                            height: 1.35,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 9,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFDF2F0),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: const Color(0xFF7A2E1D)
                                                      .withOpacity(0.2),
                                                ),
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.headphones_rounded,
                                                      size: 13,
                                                      color: Color(0xFF7A2E1D)),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    'Audio-guía',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color(0xFF7A2E1D),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (lugar.videoAsset != null) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 9,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFFFFBEB),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: const Color(
                                                            0xFFD97706)
                                                        .withOpacity(0.3),
                                                  ),
                                                ),
                                                child: const Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .videocam_rounded,
                                                        size: 13,
                                                        color:
                                                            Color(0xFFD97706)),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      'Video HD',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xFFD97706),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Colors.black26,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 5),
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

  Widget _buildFilterChip(String clave, String etiqueta, IconData icono) {
    final activo = _filtroActivo == clave;
    return ChoiceChip(
      showCheckmark: false,
      avatar: Icon(
        icono,
        size: 16,
        color: activo ? Colors.white : const Color(0xFF7A2E1D),
      ),
      label: Text(
        etiqueta,
        style: TextStyle(
          color: activo ? Colors.white : const Color(0xFF7A2E1D),
          fontWeight: activo ? FontWeight.bold : FontWeight.w600,
          fontSize: 12.5,
        ),
      ),
      selected: activo,
      selectedColor: const Color(0xFF7A2E1D),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: activo ? const Color(0xFF7A2E1D) : const Color(0xFFE5E7EB),
        ),
      ),
      onSelected: (_) => setState(() => _filtroActivo = clave),
    );
  }
}
