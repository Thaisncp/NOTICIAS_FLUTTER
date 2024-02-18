'use strict';
var formidable = require('formidable');
var models = require('../models');
var fs = require('fs');
const { where } = require('sequelize');
var persona = models.persona;
var noticia = models.noticia;
var extensiones = ['png', 'jpg'];
class NoticiaControl {
    async listar(req, res) {
        var lista = await noticia.findAll({
            include: [
                { model: models.persona, as: 'persona', attributes: ['apellidos', 'nombres', 'external_id'] },
            ],
            attributes: ['titulo', 'cuerpo', ['external_id', 'id'], 'tipo_archivo', 'tipo_noticia', 'fecha', 'archivo', 'estado']
        });
        res.status(200);
        res.json({ msg: "OK", code: 200, datos: lista });
    }

    async obtener(req, res) {
        const external = req.params.external;
        var lista = await noticia.findOne({
            where: { external_id: external },
            include: [
                { model: models.persona, as: 'persona', attributes: ['apellidos', 'nombres'] },
            ],
            attributes: ['titulo', 'cuerpo', ['external_id', 'id'], 'tipo_archivo', 'tipo_noticia', 'fecha', 'archivo', 'estado']
        });
        if (lista === undefined || lista == null) {
            res.status(200);
            res.json({ msg: "OK", code: 200, datos: {} });
        } else {
            res.status(200);
            res.json({ msg: "OK", code: 200, datos: lista });
        }
    }

    async guardar(req, res) {
        if (req.body.hasOwnProperty('titulo') &&
            req.body.hasOwnProperty('cuerpo') &&
            req.body.hasOwnProperty('fecha') &&
            req.body.hasOwnProperty('tipo_noticia') &&
            req.body.hasOwnProperty('persona')) {
            var uuid = require('uuid');
            var perAux = await persona.findOne({
                where: { external_id: req.body.persona },
                include: [
                    { model: models.rol, as: 'rol', attributes: ['nombre'] }
                ]
            });

            if (perAux == undefined || perAux == null) {
                res.status(401);
                res.json({ msg: "Error", tag: "No se encuentra el editor", code: 401 });
            } else {
                var data = {
                    cuerpo: req.body.cuerpo,
                    external_id: uuid.v4(),
                    titulo: req.body.titulo,
                    fecha: req.body.fecha,
                    tipo_noticia: req.body.tipo_noticia,
                    id_persona: perAux.id,
                    estado: false,
                    archivo: 'noticia.png',
                };
                if (perAux.rol.nombre == 'EDITOR') {
                    var result = await noticia.create(data);
                    if (result === null) {
                        res.status(401);
                        res.json({ msg: "ERROR", tag: "No se puede crear", code: 401 });
                    } else {
                        perAux.external_id = uuid.v4();
                        await perAux.save();
                        res.status(200);
                        res.json({ msg: "OK", code: 200 });
                    }
                } else {
                    res.status(400);
                    res.json({ msg: "Error", tag: "La persona no es un editor", code: 400 });
                }
            }
        } else {
            res.status(400);
            res.json({ msg: "Error", tag: "Faltan datos", code: 400 });
        }

    }

    async modificarNoticiaFoto(req, res) {
        var form = new formidable.IncomingForm(), files = [];
        form.on('file', function (field, file) {
            files.push(file);
        }).on('end', function () {
            console.log('OK');
        });

        form.parse(req, async function (err, fields) {
            console.log(files);
            const totalSize = files.reduce((acc, file) => acc + file.size, 0);
            if (totalSize > 2 * 1024 * 1024) {
                // Verificar si el tamaño del archivo excede el límite (2MB)
                res.status(400);
                res.json({ msg: 'error', tag: 'Archivo demasiado grande. Máximo permitido: 2MB', code: 400 });
                return; // Detener la ejecución si el archivo excede el tamaño límite
            }
            let listado = files;
            let nameArchivo = fields.nameArchivo[0];
            let external = fields.external[0];
            var noti = await noticia.findOne({ where: { external_id: external } });
            if (noti === null) {
                console.log("valio");
                res.status(400);
                res.json({
                    msg: "No existe registro",
                    code: 400
                });
            } else {
                for (let index = 0; index < listado.length; index++) {
                    var file = listado[index];
                    var extenseion = file.originalFilename.split('.').pop().toLowerCase();
                    if (extensiones.includes(extenseion)) {
                        console.log(extenseion);
                        const name = (noti.archivo === "noticia.png") ? nameArchivo + "." + extenseion : noti.archivo;
                        fs.rename(file.filepath, "public/multimedia/" + name, async function (error) {
                            if (error) {
                                res.status(400);
                                res.json({ msg: 'error', tag: "nose pudo guardar", code: 400 });
                            } else {
                                var uuid = require('uuid');
                                noti.archivo = name,
                                    noti.external_id = uuid.v4();
                                var result = await noti.save();
                                if (result === null) {
                                    res.status(400);
                                    res.json({
                                        msg: "No se ha modificado sus datos",
                                        code: 400
                                    });
                                } else {
                                    res.status(200);
                                    res.json({
                                        msg: "Se ha modificado sus datos",
                                        code: 200
                                    });
                                }
                            }
                        });
                    } else {
                        res.status(400);
                        res.json({ msg: 'error', tag: "solo soporta png y jpg", code: 400 });
                    }
                }
            }
        });

    }

    async modificar(req, res) {
        console.log("ENTRO EN EL METODO")
        var newNoti = await noticia.findOne({ where: { external_id: req.body.external_id } });
        if (newNoti === null) {
            console.log("valio");
            res.status(400);
            res.json({
                msg: "No existe registro",
                code: 400
            });
        } else {
                var uuid = require('uuid');
                newNoti.cuerpo = req.body.cuerpo,
                newNoti.titulo = req.body.titulo,
                newNoti.fecha = req.body.fecha,
                newNoti.tipo_noticia = req.body.tipo_noticia,
                newNoti.external_id = uuid.v4();
                var result = await newNoti.save();
                if (result === null) {
                    res.status(400);
                    res.json({
                        msg: "No se ha modificado sus datos",
                        code: 400
                    });
                } else {
                    res.status(200);
                    res.json({
                        msg: "Se ha modificado sus datos",
                        code: 200
                    });
                }
        }
    }
}
module.exports = NoticiaControl;