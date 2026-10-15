var database = require("../database/config");

function autenticar(email, senha) {
    var instrucaoSql = `
        SELECT idUsuario AS id, nome, email, fkEmpresa AS empresaId
        FROM Usuario
        WHERE email = ? AND senha = ?;
    `;

    return database.executar(instrucaoSql, [email, senha]);
}

function cadastrar(nome, documento, telefone, email, dtNasc, senha, fkEmpresa) {
    var instrucaoSql = `
        INSERT INTO Usuario (nome, documento, telefone, email, senha, dtNasc, fkEmpresa)
        VALUES (?, ?, ?, ?, ?, ?, ?);
    `;

    return database.executar(instrucaoSql, [nome, documento, telefone, email, senha, dtNasc, fkEmpresa]);
}

module.exports = {
    autenticar,
    cadastrar
};
