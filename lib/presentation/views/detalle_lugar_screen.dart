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
      backgroundColor: const Color(0xFF0F1115),
      body: CustomScrollView(
        slivers: [
          // SliverAppBar Hero Imperial HD
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            backgroundColor: const Color(0xFF14171D),
            foregroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      _esFavorito
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: _esFavorito
                          ? const Color(0xFFEF4444)
                          : Colors.white,
                      size: 22,
                    ),
                    onPressed: () {
                      setState(() => _esFavorito = !_esFavorito);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF1E222A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Color(0xFFD4AF37)),
                          ),
                          duration: const Duration(seconds: 2),
                          content: Text(
                            _esFavorito
                                ? '❤️ Guardado en tus lugares favoritos'
                                : 'Eliminado de tus favoritos',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              title: Text(
                widget.lugar.nombre,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 12,
                      offset: Offset(0, 3),
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
                        color: const Color(0xFF1F242D),
                        child: const Icon(Icons.image_not_supported,
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
                          Colors.black54,
                          Colors.transparent,
                          Color(0xFF0F1115),
                        ],
                        stops: [0.0, 0.45, 1.0],
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
                constraints: const BoxConstraints(maxWidth: 850),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge de Categoría con Borde Dorado
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    const Color(0xFFD4AF37).withOpacity(0.6),
                                width: 1,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.account_balance,
                                    size: 14, color: Color(0xFFD4AF37)),
                                SizedBox(width: 8),
                                Text(
                                  'PATRIMONIO HISTÓRICO NACIONAL',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                    color: Color(0xFFF3E5AB),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Tarjeta de Reseña Histórica
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF181B22),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF2A2E39),
                            width: 1,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 14,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD4AF37),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Reseña Histórica',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              widget.lugar.descripcion,
                              style: const TextStyle(
                                fontSize: 15.5,
                                height: 1.65,
                                color: Color(0xFFD1D5DB),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Reproductor de Audio-guía Interactivo Luxury Dark
                      AnimatedBuilder(
                        animation: _viewModel,
                        builder: (context, _) {
                          final sonando = _viewModel.reproduciendo;
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: sonando
                                    ? [
                                        const Color(0xFF9E3D24),
                                        const Color(0xFFB45309),
                                        const Color(0xFF7A2E1D),
                                      ]
                                    : [
                                        const Color(0xFF181B22),
                                        const Color(0xFF1E222C),
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: sonando
                                    ? const Color(0xFFD4AF37)
                                    : const Color(0xFF2A2E39),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (sonando
                                          ? const Color(0xFF9E3D24)
                                          : Colors.black)
                                      .withOpacity(0.4),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(22),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: sonando
                                            ? Colors.white.withOpacity(0.2)
                                            : const Color(0xFFD4AF37)
                                                .withOpacity(0.15),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFFD4AF37)
                                              .withOpacity(0.4),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.headphones_rounded,
                                        color: sonando
                                            ? Colors.white
                                            : const Color(0xFFD4AF37),
                                        size: 26,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Audio-guía Narrada',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 19,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            sonando
                                                ? '▶ Reproduciendo narración histórica...'
                                                : 'Toca para iniciar la experiencia en audio',
                                            style: TextStyle(
                                              color: sonando
                                                  ? const Color(0xFFF3E5AB)
                                                  : const Color(0xFF9CA3AF),
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Animación de ecualizador de ondas sonoras si está reproduciendo
                                if (sonando) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: List.generate(
                                        24,
                                        (idx) => AnimatedContainer(
                                          duration: Duration(
                                              milliseconds:
                                                  200 + (idx % 5) * 80),
                                          width: 3.5,
                                          height: 10.0 + (idx % 6) * 6,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF3E5AB)
                                                .withOpacity(0.9),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                // Control de Velocidad (1.0x, 1.25x, 1.5x, 2.0x)
                                Row(
                                  children: [
                                    const Text(
                                      'Velocidad:',
                                      style: TextStyle(
                                        color: Color(0xFFD1D5DB),
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ...[1.0, 1.25, 1.5, 2.0].map((v) {
                                      final seleccionada =
                                          _viewModel.velocidad == v;
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 6),
                                        child: InkWell(
                                          onTap: () =>
                                              _viewModel.cambiarVelocidad(v),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: seleccionada
                                                  ? const Color(0xFFD4AF37)
                                                  : Colors.black26,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: seleccionada
                                                    ? const Color(0xFFD4AF37)
                                                    : Colors.white24,
                                              ),
                                            ),
                                            child: Text(
                                              '${v}x',
                                              style: TextStyle(
                                                color: seleccionada
                                                    ? Colors.black
                                                    : Colors.white70,
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                                const SizedBox(height: 18),

                                // Botón principal de Reproducir / Pausar
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton.icon(
                                    onPressed: _viewModel.alternarAudio,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: sonando
                                          ? const Color(0xFFD4AF37)
                                          : const Color(0xFF9E3D24),
                                      foregroundColor: sonando
                                          ? Colors.black
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 4,
                                      shadowColor: Colors.black45,
                                    ),
                                    icon: Icon(
                                      sonando
                                          ? Icons.pause_circle_filled_rounded
                                          : Icons.play_circle_fill_rounded,
                                      size: 26,
                                    ),
                                    label: Text(
                                      sonando
                                          ? 'Pausar Audio-guía'
                                          : 'Escuchar Audio-guía',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // Sección de Recorrido Virtual en Video HD (si aplica)
                      if (_videoController != null &&
                          _videoController!.value.isInitialized) ...[
                        const SizedBox(height: 26),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF181B22),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFF2A2E39),
                              width: 1,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 16,
                                offset: Offset(0, 6),
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
                                    padding: const EdgeInsets.all(9),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE58E26)
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFE58E26)
                                            .withOpacity(0.4),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.videocam_rounded,
                                      color: Color(0xFFE58E26),
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Recorrido Virtual HD',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(18),
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
                                          : Colors.black54,
                                      child: Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _videoController!.value.isPlaying
                                                  ? _videoController!.pause()
                                                  : _videoController!.play();
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            padding: const EdgeInsets.all(18),
                                            decoration: BoxDecoration(
                                              color: _videoController!
                                                      .value.isPlaying
                                                  ? Colors.black38
                                                  : const Color(0xFF9E3D24)
                                                      .withOpacity(0.9),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: const Color(0xFFD4AF37),
                                                width: 2,
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black54,
                                                  blurRadius: 14,
                                                ),
                                              ],
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
