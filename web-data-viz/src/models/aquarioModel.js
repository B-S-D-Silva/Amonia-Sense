var database = require("../database/config");

function buscarAquariosPorEmpresa(empresaId) {
  var instrucaoSql = `
    SELECT s.idSensor AS id,
           CONCAT('Sensor ', s.idSensor, ' - ', l.cidade) AS descricao
    FROM Sensor s
    INNER JOIN Locall l ON l.idLocal = s.fkLocal
    WHERE l.fkEmpresa = ?;
  `;

  return database.executar(instrucaoSql, [empresaId]);
}

function cadastrar(empresaId, descricao) {
  
  var instrucaoSql = `INSERT INTO (descricao, fk_empresa) aquario VALUES (${descricao}, ${empresaId})`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}


module.exports = {
  buscarAquariosPorEmpresa,
  cadastrar
}
