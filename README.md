# Sistema de Detecção de Vazamentos de Amônia em Frigoríficos Bovinos

## Sobre o Projeto
Este repositório contém o código-fonte e a documentação técnica de um protótipo de Internet das Coisas (IoT) focado na detecção e no monitoramento em tempo real de vazamentos de gás amônia (NH3) em ambientes de refrigeração industrial de carne bovina.

A solução realiza a leitura de dados por meio do sensor MQ-2 conectado a um microcontrolador, envia as informações para um banco de dados relacional e apresenta os níveis de concentração de gás em uma interface web interativa com gráficos e alertas.

## Estrutura do Repositório

├── arduino/       # Código C/C++ (.ino) para o microcontrolador e sensor MQ-2
├── backend/       # Tratamento dos dados com MySQL
├── frontend/      # Painel web (HTML, CSS, JavaScript) com gráficos de monitoramento
└── documentacao/  # Documentos do projeto (contexto, escopo, premissas e restrições)

## Tecnologias Utilizadas
* **Hardware:** Microcontrolador Arduino e Sensor de Gás MQ-2.
* **Backend:** Banco de Dados MySQL.
* **Frontend:** HTML5, CSS3, JavaScript.

## Funcionalidades do Protótipo
1. **Coleta de Dados:** Leitura contínua dos valores do pino analógico do sensor MQ-2.
2. **Alerta Local:** Acionamento de alarme sonoro e sinalização visual na bancada em caso de anomalia.
3. **Persistência de Dados:** Registro histórico das leituras no MySQL com marcação de data e hora.
4. **Painel Web:** Visualização em tempo real da variação dos níveis de gás em gráficos de linha.

## Instituição
São Paulo Tech School  
Curso de Tecnologia da Informação / Análise e Desenvolvimento de Sistemas