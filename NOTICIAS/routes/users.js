let jwt = require('jsonwebtoken');
const { body, validationResult } = require('express-validator');
var express = require('express');
var router = express.Router();

const personaC = require('../app/controls/PersonaControl');
let personaControl = new personaC();

const rolC = require('../app/controls/RolControl');
let rolControl = new rolC();

const noticiaC = require('../app/controls/NoticiaControl');
let noticiaControl = new noticiaC();

const cuentaC = require('../app/controls/CuentaControl');
let cuentaControl = new cuentaC();

const comentarioC = require('../app/controls/ComentarioControl');
let comentarioControl = new comentarioC();


/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('reporte de quinto');
});
//MIDDLEWARE

const auth = function middleware(req, res, next){
  //AUTENTICACION
  const token = req.headers['news-token'];
  if(token === undefined){
    res.status(400);
    res.json({ msg: "ERROR", tag: "Falta token", code: 400 });
  }else{
    require('dotenv').config();
    const key = process.env.KEY_TNCP;
    jwt.verify(token, key, async(error, decoded) => {
      if(error){
        res.status(400);
        res.json({ msg: "ERROR", tag: "TOKEN NO VALIDO O EXPIRADO", code: 400 });
      }else{
        console.log(decoded.external);
        const models = require('../app/models');
        const cuenta = models.cuenta;
        const aux = await cuenta.findOne({
          where: {external_id : decoded.external}
        });
        if(aux === null){
          res.status(400);
        res.json({ msg: "ERROR", tag: "TOKEN NO VALIDO", code: 400 });
        }else{
          //AUTORIZACION
          next();
        }
      }
      
    });
    
  }
}

//CONTROLADOR CUENTA
router.post('/login', cuentaControl.inicio_sesion);
//CONTROLADDOR PERSONA
router.get('/admin/personas', personaControl.listar);
router.get('/admin/personas/get/:external', personaControl.obtener);
router.post('/admin/persona/save',auth, personaControl.guardar);
router.post('/admin/persona/modificar',auth,  [
  body('apellidos', 'Ingrese sus apellidos').trim().exists().not().isEmpty().isLength({ min: 3, max: 50 }).withMessage("Ingrese un valor mayor o igual a 3 y menor a 50"),
  body('nombres', 'Ingrese sus nombres').trim().exists().not().isEmpty().isLength({ min: 3, max: 50 }).withMessage("Ingrese un valor mayor o igual a 3 y menor a 50"),
],personaControl.modificar);
router.post('/admin/persona/save/usuario', personaControl.guardarUsuario);
router.post('/admin/banear', personaControl.cambiarEstadoCuenta);
//CONTROLADOR ROL
router.get('/admin/rol', rolControl.listar);
router.post('/admin/rol/save', rolControl.guardar);
//CONTROLADOR NOTICIAS
router.get('/noticias', noticiaControl.listar);
router.get('/noticias/get/:external', noticiaControl.obtener);
router.post('/admin/noticias/save',auth, noticiaControl.guardar);
router.post('/admin/noticias/modificar',auth, noticiaControl.modificar);
router.post('/admin/noticias/archivo',auth, noticiaControl.modificarNoticiaFoto);
//CONTROLADOR DE COMENTARIOS
router.post('/admin/comentario/save', [
  body('comentario', 'Ingrese un comentario').trim().exists().not().isEmpty().isLength({ min: 3, max: 200 }).withMessage("Ingrese un valor mayor o igual a 3 y menor a 200")
],comentarioControl.guardar);
router.post('/admin/comentario/mod', [
  body('comentario', 'Ingrese un comentario').trim().exists().not().isEmpty().isLength({ min: 3, max: 200 }).withMessage("Ingrese un valor mayor o igual a 3 y menor a 200")
],comentarioControl.modificar);
router.get('/admin/comentarios', comentarioControl.listar);
router.get('/admin/listaPorNoticia/:external', comentarioControl.listarPorNoticia);
router.get('/admin/listaPorUsuario/:usuario', comentarioControl.listarPorUsuario);

module.exports = router;
