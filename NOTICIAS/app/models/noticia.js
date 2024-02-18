'use strict';

module.exports = (sequelize, DataTypes) => {
    const noticia = sequelize.define('noticia', {
        titulo: { type: DataTypes.STRING(50), defaultValue: "NO_DATA" },
        cuerpo: {type: DataTypes.TEXT, defaultValue: "NO_DATA"},
        archivo: {type: DataTypes.STRING(150), defaultValue: "NO_DATA"},
        tipo_archivo: {type: DataTypes.ENUM("VIDEO", "IMAGEN"), defaultValue: "IMAGEN"},
        tipo_noticia: {type: DataTypes.ENUM("NORMAL", "DEPORTIVA", "URGENTE", "SOCIAL", "TECNOLOGICA"), defaultValue: "NORMAL"},
        fecha: { type: DataTypes.DATE, defaultValue: DataTypes.NOW},
        estado: { type: DataTypes.BOOLEAN, defaultValue: true},
        external_id: { type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4},
    }, {freezeTableName: true});

    noticia.associate = function (models){
        noticia.belongsTo(models.persona, {foreignKey: 'id_persona'});
        noticia.hasMany(models.comentario, {foreignKey: 'id_noticia', as: 'comentario'});
    };
    return noticia;
};