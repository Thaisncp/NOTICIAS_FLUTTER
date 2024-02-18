'use strict';
const moment = require('moment');
module.exports = (sequelize, DataTypes) => {
    const persona = sequelize.define('persona', {
        nombres: { type: DataTypes.STRING(150), defaultValue: "NO_DATA" },
        apellidos: { type: DataTypes.STRING(150), defaultValue: "NO_DATA" },
        direccion: {type: DataTypes.STRING, defaultValue: "NO_DATA"},
        celular: {type: DataTypes.STRING(20), defaultValue: "NO_DATA"},
        fecha_nac: {type: DataTypes.DATEONLY, defaultValue: moment().format()},
        external_id: { type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4},
    }, {freezeTableName: true});

    persona.associate = function (models){
        persona.belongsTo(models.rol, {foreignKey: 'id_rol'});
        persona.hasOne(models.cuenta, { foreignKey: 'id_persona', as: 'cuenta'});
        persona.hasMany(models.noticia, {foreignKey: 'id_persona', as: 'notica'});
    };

    return persona;
};