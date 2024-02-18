'use strict';

var models = require('../models');
var persona = models.persona;
var cuenta = models.cuenta;
var rol = models.rol;
let jwt = require('jsonwebtoken');

class CuentaControl {
    async inicio_sesion(req, res){
        if (req.body.hasOwnProperty('correo') &&
            req.body.hasOwnProperty('clave')){
                let cuentaAux = await cuenta.findOne({
                    where : {correo: req.body.correo},
                    include: [
                        { model: models.persona, as: 'persona', attributes: ['apellidos', 'nombres', 'external_id', 'id_rol'],
                     },
                    ],
                });
                if(cuentaAux === null){
                    res.status(400);
                    res.json({ msg: "ERROR", tag: "Cuenta no existe", code: 400 });
                }else{
                    var rolAux = await rol.findOne({
                        where: { id: cuentaAux.persona.id_rol }
                    });
                    if(cuentaAux.estado == true){
                        if(cuentaAux.clave === req.body.clave){
                            const token_data = {
                                external: cuentaAux.external_id,
                                check: true
                            };
                            require('dotenv').config();
                            const key = process.env.KEY_TNCP;
                            const token = jwt.sign(token_data, key, {
                                expiresIn: '2h'
                            });
                            var info = {
                                token: token,
                                user: cuentaAux.persona.apellidos+' '+cuentaAux.persona.nombres,
                                external: cuentaAux.persona.external_id,
                                rol: rolAux.nombre,
                            };
                            res.status(200);
                            res.json({ msg: "OK", tag: "listo",datos:info, code: 200 });
                            
                        }else{
                            res.status(400);
                            res.json({ msg: "ERROR", tag: "clave incorrecta", code: 400 });
                        }
                    }else{
                        res.status(400);
                        res.json({ msg: "ERROR", tag: "cuenta desactivada", code: 400 });
                    }
                }
            }else{
                res.status(400);
                res.json({ msg: "ERROR", tag: "Faltan datos", code: 400 });
            }
    }
}

module.exports = CuentaControl;