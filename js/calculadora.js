let custoSensor = 96; // sendo 40 o valor do MQ-2 e 56 o valor do UNO-R3
let custoInstalacao = 120;
let tipoTempo = 'padrao';

function calcularHardware(){
    let evaporadores = Number(input_evaporadores.value);
    let sensores = Number(input_sensores.value);

    let totalSensores = evaporadores * sensores;
    let custoPorSensor = custoSensor + custoInstalacao;
    let custoTotal = totalSensores * custoPorSensor;

    div_msgHardware.innerHTML = `
        <div class="resultado-caixa resultado-info">
            Total de sensores necessários: <b>${totalSensores}</b><br>
            Custo estimado de implantação do sistema: <b>R$ ${custoTotal.toFixed(2)}<br>
            Utilizamos os valores -> Arduino: R$${custoTotal*0.25} | Sensor: R$${custoTotal*0.10} | Proto-Board: R$${custoTotal*0.05} |  Instalação: R$${custoTotal*0.6}
                </b>
        </div>
    `;
}

function calcularTrabalhista(){
    let numeroFuncionarios = Number(input_numeroFuncionarios.value);
    let mesesExpo = Number(input_mesesExpo.value);

    if (mesesExpo > 60){
        mesesExpo = 60;
    }

    let valor = numeroFuncionarios * 324.2 * mesesExpo;
    let valorComReflexos = valor * 1.27;

    div_msgTrabalhista.innerHTML = `
        <div class="resultado-caixa resultado-erro">
            Adicional de insalubridade estimado: <b>R$ ${valor.toFixed(2)}</b><br>
            Com reflexos (13º salário, férias e FGTS): <b class="destaque-vermelho">R$ ${valorComReflexos.toFixed(2)}</b><br>
            <span class="subtitulo"><i>Valor estimado considerando o teto legal de 60 meses.</i></span>
        </div>
    `;
}

function exibirHora(){
    tempo.innerHTML = `<label>Tempo de paralisação causado pelo vazamento (horas):</label> <br><input placeholder="Ex: 1" type="number" id="input_hora"><br><br>`;
    tipoTempo = 'hora';
}

function exibirMinutos(){
    tempo.innerHTML = `<label>Tempo de paralisação causado pelo vazamento (minutos):</label> <br><input placeholder="Ex: 60" type="number" id="input_minutos"><br><br>`;
    tipoTempo = 'minuto';
}

function calcularIncidente() {
    let capacidadeDiaria = Number(input_capacidade.value);
    let horasFuncionamento = Number(input_funcionamento.value);
    let pesoCarcaca = 267.3;
    let custoPorKg = Number(input_custokg.value);
    let Funcionarios = Number(ipt_Funcionarios.value);
    let HoraFuncionario = Number(ipt_HoraFuncionario.value);

    let minutosParado = 0;

    if (tipoTempo != 'hora') {
        minutosParado = Number(input_minutos.value);
    } else {
        minutosParado = Number(input_hora.value) * 60;
    }

    let bovinosPorHora = capacidadeDiaria / horasFuncionamento;
    let kgDeCarnePorHora = bovinosPorHora * pesoCarcaca;
    let kgDeCarnePorMinuto = kgDeCarnePorHora / 60;

    let kgDeCarneContaminada = kgDeCarnePorMinuto * minutosParado;
    let prejuizoCarneContaminada = kgDeCarneContaminada * custoPorKg;

    let valorMinutoFuncionario = HoraFuncionario / 60;
    let PrejuizoMaoDeObra = Funcionarios * valorMinutoFuncionario * minutosParado;

    let prejuizoTotal = prejuizoCarneContaminada + PrejuizoMaoDeObra;

    div_msgIncidente.innerHTML = `
        <div class="resultado-caixa resultado-erro">
            Resultado para uma paralisação de ${minutosParado} minutos:<br><br>
            <b>Carne contaminada:</b> <span class="destaque-vermelho">${kgDeCarneContaminada.toFixed(2)} kg perdidos.</span><br>
            <b>Prejuízo com a carne:</b> <span class="destaque-vermelho">R$ ${prejuizoCarneContaminada.toFixed(2)}</span><br>
            <b>Custo de Mão de Obra Ociosa:</b> <span class="destaque-vermelho">R$ ${PrejuizoMaoDeObra.toFixed(2)} baseado em ${Funcionarios} funcionários custando R$${HoraFuncionario} por hora com o funcionamento da desossa sendo de ${horasFuncionamento} horas!</span><br><br>
            <b>PREJUÍZO TOTAL DO ACIDENTE:</b> <span class="destaque-total">R$ ${prejuizoTotal.toFixed(2)} baseado em ${capacidadeDiaria} carcaças bovinas, com peso médio de 267.3KG cada, custando R$${custoPorKg} por KG!</span>
        </div>
    `;
}