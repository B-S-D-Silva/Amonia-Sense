var usuarioModel = require("../models/usuarioModel");
var aquarioModel = require("../models/aquarioModel");

async function autenticar(req, res) {
    var email = req.body && req.body.emailServer;
    var senha = req.body && req.body.senhaServer;

    if (!email || !senha) {
        return res.status(400).send("E-mail e senha são obrigatórios.");
    }

    try {
        var resultadoAutenticar = await usuarioModel.autenticar(email, senha);

        if (resultadoAutenticar.length !== 1) {
            return res.status(403).send("E-mail e/ou senha inválido(s).");
        }

        var usuario = resultadoAutenticar[0];
        var sensores = await aquarioModel.buscarAquariosPorEmpresa(usuario.empresaId);

        return res.status(200).json({
            id: usuario.id,
            email: usuario.email,
            nome: usuario.nome,
            aquarios: sensores
        });
    } catch (erro) {
        console.error("Houve um erro ao realizar o login:", erro);
        return res.status(500).send("Não foi possível autenticar o usuário.");
    }
}

async function cadastrar(req, res) {
    var dados = req.body || {};
    var nome = dados.nomeServer;
    var documento = dados.documentoServer;
    var telefone = dados.telefoneServer;
    var email = dados.emailServer;
    var dtNasc = dados.dtNascServer;
    var senha = dados.senhaServer;
    var fkEmpresa = Number(dados.idEmpresaVincularServer);

    if (!nome || !documento || !telefone || !email || !dtNasc || !senha || !Number.isInteger(fkEmpresa) || fkEmpresa < 1) {
        return res.status(400).send("Preencha todos os campos obrigatórios do cadastro.");
    }

    try {
        var resultado = await usuarioModel.cadastrar(nome, documento, telefone, email, dtNasc, senha, fkEmpresa);
        return res.status(201).json({ id: resultado.insertId });
    } catch (erro) {
        console.error("Houve um erro ao cadastrar o usuário:", erro);
        if (erro.code === "ER_DUP_ENTRY") {
            return res.status(409).send("Já existe um usuário com esse documento ou e-mail.");
        }
        return res.status(500).send("Não foi possível cadastrar o usuário.");
    }
}

module.exports = {
    autenticar,
    cadastrar
};
