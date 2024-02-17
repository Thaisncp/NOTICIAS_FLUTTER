import 'package:flutter/material.dart';
import 'package:unidad3/views/ComentariosScreen.dart';
import 'package:unidad3/views/ComentariosUsuarios.dart';
import 'package:unidad3/views/EditarDatosPersona.dart';
import 'package:unidad3/views/MapaComentariosScreen.dart';
import 'package:unidad3/views/NoticiasScreen.dart';
import 'package:unidad3/views/RegisterView.dart';
import 'package:unidad3/views/exception/Page404View.dart';
import 'package:unidad3/views/sessionView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey).copyWith(background: Color(0xff1a3854)),
      ),
      home: const SessionView(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => SessionView(),
        'register': (context) => RegisterView(),
        '/principal': (context) => NoticiasScreen(),
        '/comentarios': (context) => ComentariosScreen(),
        '/comentariosUsuario': (context) => ComentariosUsuarios(),
        '/editarPersona': (context) => EditarDatosPersona(),
        '/mapa': (context) => MapaComentariosScreen()
      },
      onGenerateRoute: (settings){
        return MaterialPageRoute(builder: (context) => const Page404View());
      },
    );
  }
}

