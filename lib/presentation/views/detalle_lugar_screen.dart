import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entities/lugar_turistico.dart';
import '../viewmodels/detalle_view_model.dart';

class DetalleLugarScreen extends StatefulWidget {
  final LugarTuristico lugar;
  const DetalleLugarScreen({super.key, required this.lugar});

  @override
  State<DetalleLugarScreen> createState() => _DetalleLugarScreenState();
}

class _DetalleLugarScreenState extends State<DetalleLugarScreen> {
  late final DetalleViewModel _viewModel;
  VideoPlayerController? _videoController;
  bool _esFavorito = false;

  @override
  void initState() {
    super.initState();
    _viewModel = DetalleViewModel(widget.lugar);
    final video = widget.lugar.videoAsset;
    if (video != null) {
      _videoController = VideoPlayerController.asset(video)
        ..initialize().then((_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar con Imagen HD Hero
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: const Color(0xFF7A2E1D),
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: Icon(
                  _esFavorito ? Icons.favorite : Icons.favorite_border,
                  color: _esFavorito ? Colors.redAccent : Colors.white,
                ),
                onPressed: () {
                  setState(() => _esFavorito = !_esFavorito);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 1),
                      content: Text(
                        _esFavorito
                            ? 'Añadido a tus lugares favoritos'
                            : 'Eliminado de tus favoritos',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.lugar.nombre,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      color: Colors.black87,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'lugar-img-${widget.lugar.id}',
                    child: Image.asset(
                      widget.lugar.imagenAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image,
                            size: 64, color: Colors.grey),
                      ),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black38,
                          Colors.transparent,
                          Colors.black87,
                        ],
                        stops: [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contenido Detallado
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge de Categoría
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF2F0),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF7A2E1D).withOpacity(0.3),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.account_balance,
                                    size: 14, color: Color(0xFF7A2E1D)),
                                SizedBox(width: 6),
                                Text(
                                  'PATRIMONIO HISTÓRICO NACIONAL',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                    color: Color(0xFF7A2E1D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Tarjeta de Descripción
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Reseña Histórica',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.lugar.descripcion,
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: Color(0xFF374151),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Reproductor de Audio-guía Interactivo
                      AnimatedBuilder(
                        animation: _viewModel,
                        builder: (context, _) {
                          final sonando = _viewModel.reproduciendo;
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: sonando
                                    ? [
                                        const Color(0xFFB45309),
                                        const Color(0xFFD97706)
                                      ]
                                    : [
                                        const Color(0xFF7A2E1D),
                                        const Color(0xFF9E3D24)
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: (sonando
                                          ? const Color(0xFFD97706)
                                          : const Color(0xFF7A2E1D))
                                      .withOpacity(0.35),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.headphones_rounded,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Audio-guía Narrada',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            sonando
                                                ? '▶ Reproduciendo narración histórica...'
                                                : 'Toca para iniciar la narración',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                // Visualizador simulación de ondas sonoras si está reproduciendo
                                if (sonando) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(
                                      16,
                                      (idx) => Container(
                                        width: 4,
                                        height: 12.0 + (idx % 4) * 8,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton.icon(
                                    onPressed: _viewModel.alternarAudio,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: sonando
                                          ? const Color(0xFFB45309)
                                          : const Color(0xFF7A2E1D),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 0,
                                    ),
                                    icon: Icon(
                                      sonando
                                          ? Icons.pause_circle_filled_rounded
                                          : Icons.play_circle_fill_rounded,
                                      size: 28,
                                    ),
                                    label: Text(
                                      sonando
                                          ? 'Pausar Narración'
                                          : 'Escuchar Audio-guía',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // Sección de Recorrido en Video HD (si está presente)
                      if (_videoController != null &&
                          _videoController!.value.isInitialized) ...[
                        const SizedBox(height: 24),
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.videocam_rounded,
                                        color: Color(0xFFD97706), size: 24),
                                    SizedBox(width: 10),
                                    Text(
                                      'Recorrido Virtual en Video HD',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: _videoController!
                                            .value.aspectRatio,
                                        child: VideoPlayer(_videoController!),
                                      ),
                                      Container(
                                        color: _videoController!.value.isPlaying
                                            ? Colors.transparent
                                            : Colors.black38,
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _videoController!.value.isPlaying
                                                    ? _videoController!.pause()
                                                    : _videoController!.play();
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.black45,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white54,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Icon(
                                                _videoController!.value.isPlaying
                                                    ? Icons.pause_rounded
                                                    : Icons.play_arrow_rounded,
                                                color: Colors.white,
                                                size: 44,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
