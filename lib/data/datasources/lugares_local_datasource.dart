import '../../domain/entities/lugar_turistico.dart';

class LugaresLocalDataSource {
  List<LugarTuristico> obtenerLugares() {
    return [
      const LugarTuristico(
        id: '1',
        nombre: 'Jardín Principal (Plaza de la Constitución)',
        descripcion:
            'El corazón social e histórico de la Cuna de la Independencia. Rodeado de portales coloniales, centenarios laureles de la India y bancas de hierro forjado. En su centro destaca el quiosco de estilo porfiriano.',
        imagenAsset: 'assets/images/jardin_principal.jpg',
        audioAsset: 'audio/jardin_principal.mp3',
        videoAsset: 'assets/video/jardin_principal.mp4',
      ),
      const LugarTuristico(
        id: '2',
        nombre: 'Parroquia de Nuestra Señora de los Dolores',
        descripcion:
            'Joya del barroco churrigueresco del siglo XVIII con su emblemática fachada de cantera rosa. En sus escalinatas, la madrugada del 16 de septiembre de 1810, el cura Miguel Hidalgo dio el histórico Grito de Dolores.',
        imagenAsset: 'assets/images/parroquia.jpg',
        audioAsset: 'audio/parroquia.mp3',
      ),
      const LugarTuristico(
        id: '3',
        nombre: 'Museo Casa de Hidalgo',
        descripcion:
            'Casona colonial del siglo XVIII donde residió Miguel Hidalgo y Costilla. Preserva mobiliario original, documentos históricos, objetos personales y lienzos de la época insurgente.',
        imagenAsset: 'assets/images/museo_hidalgo.jpg',
        audioAsset: 'audio/museo_hidalgo.mp3',
      ),
    ];
  }
}
