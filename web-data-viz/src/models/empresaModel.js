var database = require("../database/config");

function buscarPorId(id) {
  var instrucaoSql = `
    SELECT idEmpresa AS id, nomeFantasia AS razao_social, cnpj
    FROM Empresa
    WHERE idEmpresa = ?;
  `;

  return database.executar(instrucaoSql, [id]);
}

function listar() {
  var instrucaoSql = `
    SELECT idEmpresa AS id, nomeFantasia AS nome, cnpj
    FROM Empresa
    ORDER BY nomeFantasia;
  `;

  return database.executar(instrucaoSql);
}

function buscarPorCnpj(cnpj) {
  var instrucaoSql = `
    SELECT idEmpresa AS id, nomeFantasia AS razao_social, cnpj
    FROM Empresa
    WHERE cnpj = ?;
  `;

  return database.executar(instrucaoSql, [cnpj]);
}

function cadastrar(razaoSocial, cnpj) {
  var instrucaoSql = `
    INSERT INTO Empresa (nomeFantasia, cnpj)
    VALUES (?, ?);
  `;

  return database.executar(instrucaoSql, [razaoSocial, cnpj]);
}

module.exports = { buscarPorCnpj, buscarPorId, cadastrar, listar };
