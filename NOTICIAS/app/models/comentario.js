'use strict';

module.exports = (sequelize, DataTypes) => {
    const comentario = sequelize.define('comentario', {
        cuerpo: { type: DataTypes.STRING(500), defaultValue: "NO_DATA" },
        estado:{type: DataTypes.BOOLEAN, defaultValue: true},
        usuario:{type: DataTypes.STRING(500), defaultValue: "NO_DATA"},
        longitud: { type: DataTypes.DECIMAL(50, 2), defaultValue: 0.00 },
        latitud: { type: DataTypes.DECIMAL(50, 2), defaultValue: 0.00 },
        external_id: { type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4},
    }, {freezeTableName: true});

    comentario.associate = function (models){
        comentario.belongsTo(models.noticia, {foreignKey: 'id_noticia'});
    };

    return comentario;
};