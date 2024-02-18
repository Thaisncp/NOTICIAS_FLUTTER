'use strict';

var models = require('../models');
var persona = models.persona;
var rol = models.rol;
var cuenta = models.cuenta;
var comentario = models.comentario;

class PersonaControl {
    async listar(req, res) {
        var lista = await persona.findAll({

            include: [
                { model: models.cuenta, as: 'cuenta', attributes: ['correo'] },
                { model: models.rol, as: 'rol', attributes: ['nombre'] }
            ],
            attributes: ['apellidos', 'nombres', 'direccion', 'celular', ['external_id', 'id'], 'fecha_nac']
        });
        res.status(200);
        res.json({ msg: "OK", code: 200, datos: lista });
    }

    async obtener(req, res) {
        const external = req.params.external;
        var lista = await persona.findOne({
            where: { external_id: external },
            include: [
                { model: models.cuenta, as: 'cuenta', attributes: ['correo'] },
                { model: models.rol, as: 'rol', attributes: ['nombre'] }
            ],
            attributes: ['apellidos', 'nombres', 'direccion', 'celular', 'external_id', 'fecha_nac']
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
        if (req.body.hasOwnProperty('nombres') &&
            req.body.hasOwnProperty('apellidos') &&
            req.body.hasOwnProperty('direccion') &&
            req.body.hasOwnProperty('celular') &&
            req.body.hasOwnProperty('fecha_nac') &&
            req.body.hasOwnProperty('correo') &&
            req.body.hasOwnProperty('clave') &&
            req.body.hasOwnProperty('rol')) {
            var uuid = require('uuid');
            var rolAux = await rol.findOne({ where: { external_id: req.body.rol } });
            if (rolAux != undefined) {
                var data = {
                    nombres: req.body.nombres,
                    apellidos: req.body.apellidos,
                    direccion: req.body.direccion,
                    celular: req.body.celular,
                    fecha_nac: req.body.fecha_nac,
                    id_rol: rolAux.id,
                    external_id: uuid.v4(),
                    cuenta: {
                        correo: req.body.correo,
                        clave: req.body.clave
                    }
                }
                let transaction = await models.sequelize.transaction();
                try {
                    var result = await persona.create(data, { include: [{ model: models.cuenta, as: "cuenta" }], transaction });
                    await transaction.commit();
                    if (result === null) {
                        res.status(401);
                        res.json({ msg: "ERROR", tag: "No se puede crear", code: 401 });
                    } else {
                        rolAux.external_id = uuid.v4();
                        await rolAux.save();
                        res.status(200);
                        res.json({ msg: "OK", code: 200 });
                    }
                } catch (error) {
                    if (transaction) await transaction.rollback();
                    res.status(203);
                    res.json({ msg: "Error", code: 203, error_msg: error });
                }

            } else {
                res.status(400);
                res.json({ msg: "ERROR", tag: "El dato a buscar no existe", code: 400 });
            }

        } else {
            res.status(400);
            res.json({ msg: "ERROR", tag: "Faltan datos", code: 400 });
        }

    }

    async guardarUsuario(req, res) {
        if (req.body.hasOwnProperty('nombres') &&
            req.body.hasOwnProperty('apellidos') &&
            req.body.hasOwnProperty('direccion') &&
            req.body.hasOwnProperty('celular') &&
            req.body.hasOwnProperty('correo') &&
            req.body.hasOwnProperty('clave')) {
            var uuid = require('uuid');
            var rolAux = await rol.findOne({ where: { external_id: "0a54a5b5-9761-4d59-ab65-5f8709c98896" } });
            if (rolAux != undefined) {
                var data = {
                    nombres: req.body.nombres,
                    apellidos: req.body.apellidos,
                    direccion: req.body.direccion,
                    celular: req.body.celular,
                    id_rol: rolAux.id,
                    external_id: uuid.v4(),
                    cuenta: {
                        correo: req.body.correo,
                        clave: req.body.clave
                    }
                }
                let transaction = await models.sequelize.transaction();
                try {
                    var result = await persona.create(data, { include: [{ model: models.cuenta, as: "cuenta" }], transaction });
                    await transaction.commit();
                    if (result === null) {
                        res.status(401);
                        res.json({ msg: "ERROR", tag: "No se puede crear", code: 401 });
                    } else {
                        await rolAux.save();
                        res.status(200);
                        res.json({ msg: "OK", code: 200 });
                    }
                } catch (error) {
                    if (transaction) await transaction.rollback();
                    res.status(203);
                    res.json({ msg: "Error", code: 203, error_msg: error });
                }

            } else {
                res.status(400);
                res.json({ msg: "ERROR", tag: "El dato a buscar no existe", code: 400 });
            }

        } else {
            res.status(400);
            res.json({ msg: "ERROR", tag: "Faltan datos", code: 400 });
        }

    }

    async modificar(req, res) {
        console.log("ENTRO EN EL METODO")
        var person = await persona.findOne({ where: { external_id: req.body.external } });
        if (person === null) {
            console.log("valio");
            res.status(400);
            res.json({
                msg: "ERROR", tag: "Persona no existe", code: 400
            });
        } else {
            var uuid = require('uuid');
            person.nombres = req.body.nombres,
            person.apellidos = req.body.apellidos,
            person.direccion = req.body.direccion,
            person.celular = req.body.celular,
            person.external = uuid.v4();
            var result = await person.save();
            if (result === null) {
                res.status(400);
                res.json({
                    msg: "ERROR", tag: "No se han modificado los datos", code: 400
                });
            } else {
                res.status(200);
                res.json({
                    msg: "OK", tag: "Datos modificados con exito",code: 200 
                });
            }
        }
    }

    async cambiarEstadoCuenta(req, res) {
        try {
          const idUsuario = req.body.usuario;
          const external = req.body.external_id;

          const persona = await models.persona.findOne({
            where: { external_id: idUsuario },
            include: [{ model: models.cuenta, as: 'cuenta' }],
          });
          const comentario = await models.comentario.findOne({
            where: {external_id: external }
          });
      
          if (!persona) {
            res.status(404).json({ msg: "Usuario no encontrado", code: 404});
            return;
          }
          if(!comentario){
            res.status(404).json({ msg: "Comentario no encontrado", code: 404 });
            return;
          }
      
          // Cambiar el estado de la cuenta
          persona.cuenta.estado = false;
          comentario.estado = false;
      
          // Guardar los cambios
          await persona.cuenta.save();
          await comentario.save();
      
          res.status(200).json({ msg: "Estado de cuenta cambiado exitosamente", code: 200 });
        } catch (error) {
          console.error(error);
          res.status(500).json({ msg: "Error interno del servidor", code: 500 });
        }
      }
      

}

module.exports = PersonaControl;