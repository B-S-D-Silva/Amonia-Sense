var mysql = require("mysql2");

// CONEXÃO DO BANCO MYSQL SERVER
var mySqlConfig = {
    host: process.env.DB_HOST,
    database: process.env.DB_DATABASE,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT
};

function executar(instrucao, valores = []) {

    if (process.env.AMBIENTE_PROCESSO !== "producao" && process.env.AMBIENTE_PROCESSO !== "desenvolvimento") {
        return Promise.reject(new Error("AMBIENTE NÃO CONFIGURADO EM .env"));
    }

    return new Promise(function (resolve, reject) {
        var conexao = mysql.createConnection(mySqlConfig);

        conexao.connect(function (erroConexao) {
            if (erroConexao) {
                conexao.destroy();
                reject(erroConexao);
                return;
            }

            conexao.query(instrucao, valores, function (erro, resultados) {
                conexao.end(function (erroEncerramento) {
                    if (erro) {
                        reject(erro);
                    } else if (erroEncerramento) {
                        reject(erroEncerramento);
                    } else {
                        resolve(resultados);
                    }
                });
            });
        });
    });
}

module.exports = {
    executar
};