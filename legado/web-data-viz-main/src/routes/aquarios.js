var express = require("express");
var router = express.Router();

var camaraController = require("../controllers/aquarioController");

router.get("/:empresaId", function (req, res) {
  camaraController.buscarCamarasPorEmpresa(req, res);
});

router.post("/cadastrar", function (req, res) {
  camaraController.cadastrar(req, res);
})

module.exports = router;