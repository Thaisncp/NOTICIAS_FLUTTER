'use strict';
var formidable = require('formidable');
var models = require('../models');
var persona = models.persona;
var comentario = models.comentario;
var noticia = models.noticia;
var extensiones = ['png', 'jpg'];
class NoticiaControl {
    async listar(req, res) {
        try {
            const listaComentarios = await models.comentario.findAll({
                include: [
                    { model: models.noticia, as: 'noticium', attributes: ['titulo'] },
                ],
                attributes: ['cuerpo', 'longitud', 'latitud', 'external_id', 'usuario', 'estado'], 
                where: {
                    estado: true, // Filtrar por comentarios con estado true
                },
            });
    
            res.status(200).json({ msg: "OK", code: 200, datos: listaComentarios });
        } catch (error) {
            console.error(error);
            res.status(500).json({ msg: "Error interno del servidor", code: 500 });
        }
    }

    async listarPorNoticia(req, res) {
        try {
            const externalIdNoticia = req.params.external;
            const listaComentarios = await models.comentario.findAll({
                include: [
                    {
                        model: models.noticia,
                        as: 'noticium',
                        attributes: ['titulo'],
                    },
                ],
                where: {
                    estado: true, // Filtrar por comentarios con estado true
                    '$noticium.external_id$': externalIdNoticia,
                },
                attributes: ['cuerpo', 'longitud', 'latitud', 'usuario','external_id'],
            });
    
            res.status(200).json({ msg: "OK", code: 200, datos: listaComentarios });
        } catch (error) {
            console.error(error);
            res.status(500).json({ msg: "Error interno del servidor", code: 500 });
        }
    }

    async listarPorUsuario(req, res) {
        try {
            const idUsuario = req.params.usuario;
            const listaComentarios = await models.comentario.findAll({
                where: {
                    estado: true, // Filtrar por comentarios con estado true
                    usuario: idUsuario,
                },
                attributes: ['cuerpo', 'longitud', 'latitud', 'external_id', 'usuario'],
            });
    
            res.status(200).json({ msg: "OK", code: 200, datos: listaComentarios });
        } catch (error) {
            console.error(error);
            res.status(500).json({ msg: "Error interno del servidor", code: 500 });
        }
    }
    
    async guardar(req, res) {
        if (req.body.hasOwnProperty('cuerpo') &&
            req.body.hasOwnProperty('usuario') &&
            req.body.hasOwnProperty('longitud') &&
            req.body.hasOwnProperty('latitud') &&
            req.body.hasOwnProperty('id_noticia')) {
            var uuid = require('uuid');
            var perAux = await persona.findOne({
                where: { external_id: req.body.usuario },
                include: [
                    { model: models.rol, as: 'rol', attributes: ['nombre'] }
                ]
            });

            var notiAux = await noticia.findOne({
                where: { external_id: req.body.id_noticia }
            });

            if (perAux == undefined || perAux == null) {
                res.status(401);
                res.json({ msg: "Error", tag: "No se encuentra el usuario", code: 401 });
            }else{
                if (notiAux == undefined || notiAux == null) {
                    res.status(401);
                    res.json({ msg: "Error", tag: "No se encuentra la noticia", code: 401 });
                } else {
                    var data = {
                        cuerpo: req.body.cuerpo,
                        external_id: uuid.v4(),
                        usuario: perAux.external_id,
                        longitud: req.body.longitud,
                        latitud: req.body.latitud,
                        id_noticia: notiAux.id
                    };
                    if (perAux.rol.nombre == 'USUARIO') {
                        var result = await comentario.create(data);
                        if (result === null) {
                            res.status(401);
                            res.json({ msg: "ERROR", tag: "No se puede crear", code: 401 });
                        } else {
                            res.status(200);
                            res.json({ msg: "OK", tag: "comentario creado con exito",code: 200 });
                        }
                    } else {
                        res.status(400);
                        res.json({ msg: "Error", tag: "La persona no es un usuario", code: 400 });
                    }
                }
            }
                
        } else {
            res.status(400);
            res.json({ msg: "Error", tag: "Faltan datos", code: 400 });
        }

    }


    async modificar(req, res) {
        var newComent = await comentario.findOne({ where: { external_id: req.body.external_id } });
        if (newComent === null) {
            console.log("valio");
            res.status(400);
            res.json({
                msg: 'ERROR',
                tag: "No existe registro",
                code: 400
            });
        } else {
                var uuid = require('uuid');
                newComent.cuerpo = req.body.cuerpo,
                newComent.external_id = uuid.v4();
                var result = await newComent.save();
                if (result === null) {
                    res.status(400);
                    res.json({
                        msg: "Error", tag: "error al editar", code: 400
                    });
                } else {
                    res.status(200);
                    res.json({
                        msg: "OK", tag: "comentario editado con exito",code: 200
                    });
                }
        }
    }
}
module.exports = NoticiaControl;