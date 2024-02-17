import 'package:unidad3/controls/utiles/Utiles.dart';
import 'package:flutter/material.dart';

Future<String?> _obtenerRol() async {
  Utiles util = Utiles();
  var rol = await util.getValue("rol");
  return rol;
}

class MenuBarP extends StatelessWidget {
  const MenuBarP({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _obtenerRol(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            // Manejar el error o falta de rol
            return Container();
          }

          // Obtener el rol
          String rol = snapshot.data!;

          // Construir las opciones del menú según el rol
          List<PopupMenuEntry<int>> menuItems = [];

          if (rol == "ADMINISTRADOR") {
            menuItems.addAll([
              PopupMenuItem<int>(
                value: 1,
                child: Text("Inicio"),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text("Mapa"),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Text("Comentarios"),
              ),
            ]);
          } else if (rol == "USUARIO" || rol == "EDITOR") {
            menuItems.addAll([
              PopupMenuItem<int>(
                value: 1,
                child: Text("Inicio"),
              ),
              PopupMenuItem<int>(
                value: 4,
                child: Text("Editar Datos"),
              ),
              PopupMenuItem<int>(
                value: 5,
                child: Text("Editar Comentarios"),
              ),
            ]);
          }

          menuItems.add(
            PopupMenuItem<int>(
              value: 6,
              child: Text("Cerrar Sesión"),
            ),
          );

          return PopupMenuButton(
            itemBuilder: (context) => menuItems,
            onSelected: (value) {
              if (value == 6) {
                Utiles util = Utiles();
                util.removeAllItem();
                final SnackBar mensaje = SnackBar(content: Text('¡Hasta luego!'));
                ScaffoldMessenger.of(context).showSnackBar(mensaje);
                Navigator.pushNamed(context, '/home');
              } else if (value == 1) {
                Navigator.pushNamed(context, '/principal');
              } else if (value == 2) {
                Navigator.pushNamed(context, '/mapa');
              } else if (value == 3) {
                Navigator.pushNamed(context, '/comentarios');
              } else if (value == 4) {
                Navigator.pushNamed(context, '/editarPersona');
              } else if (value == 5) {
                Navigator.pushNamed(context, '/comentariosUsuario');
              }
            },
          );
        } else {
          // Mientras se carga el rol, puedes mostrar un indicador de carga o algo similar
          return CircularProgressIndicator();
        }
      },
    );
  }
}

