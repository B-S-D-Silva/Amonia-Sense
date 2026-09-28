# Sistema de Detecção de Vazamentos de Amônia em Frigoríficos Bovinos

## Sobre o Projeto
Este repositório contém o código-fonte e a documentação técnica de um protótipo de Internet das Coisas (IoT) focado na detecção e no monitoramento em tempo real de vazamentos de gás amônia (NH3) em ambientes de refrigeração industrial de carne bovina.

A solução realiza a leitura de dados por meio do sensor MQ-2 conectado a um microcontrolador, envia as informações para um banco de dados relacional e apresenta os níveis de concentração de gás em uma interface web interativa com gráficos e alertas.
> **Nota:** Para fins de prototipagem e simulação didática em ambiente acadêmico, foi utilizado o sensor analógico MQ-2 para representar a captação de gases inflamáveis/voláteis. Em uma aplicação industrial real de amônia ($NH_3$), adota-se preferencialmente sensores específicos para este fim (como a linha MQ-137 ou detectores eletroquímicos homologados).

## Estrutura do Repositório

```plaintext
├─ arduino/      # Código C/C++ (.ino) para microcontrolador e sensor MQ-2
├─ backend/      # Tratamento dos dados e integração com MySQL
├─ frontend/     # Painel web (HTML, CSS, JavaScript) com gráficos de monitorização
└─ documentacao/ # Documentos do projeto (contexto, escopo, premissas e restrições)
```

## Tecnologias Utilizadas
* **Hardware:** Microcontrolador Arduino e Sensor de Gás MQ-2.
* **Backend:** JavaScript, HTML5.
* **Banco de Dados:** MySQL Workbench.
* **Frontend:** HTML5, CSS3.

## Funcionalidades do Protótipo
1. **Coleta de Dados:** Leitura contínua dos valores do pino analógico do sensor MQ-2.
2. **Alerta Local:** Acionamento de alarme sonoro e sinalização visual na bancada em caso de anomalia.
3. **Persistência de Dados:** Registro histórico das leituras no MySQL com marcação de data e hora.
4. **Painel Web:** Visualização em tempo real da variação dos níveis de gás em gráficos de linha.

## Como Executar o Projeto

### Pré-requisitos
- [Git](https://git-scm.com/) instalado.
- [Arduino IDE](https://www.arduino.cc/en/software) (para carregar o código na placa).
- SGBD [MySQL Workbench](https://www.mysql.com/products/workbench/) ou equivalente.
- Navegador web atualizado (Chrome, Edge, Firefox).

---

### Passo a Passo

#### 1. Clonar o repositório
Abra o terminal (Git Bash, Prompt de Comando ou PowerShell) e execute:
```bash
git clone [https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git](https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git)
cd SEU_REPOSITORIO
```
#### 2. Configurar o Banco de Dados (MySQL)
Execute o script de criação das tabelas localizado na pasto do projeto:
``` SQL
-- Execute o arquivo .sql presente na pasta backend/ ou documentacao;
```
#### 3. Configurar e rodar o Arduino
- Abra o Arduino IDE.
- Conecte o microcontrolador via USB.
- Abra o arquivo .ino localizado em arduino/.
- Selecione a porta COM correspondente e clique em Carregar (Upload).

#### 4. Execute a Interface Web (Frontend)
- Acesse a pasta frontend/.
- Dê dois cliques no arquivo index.html para abrir diretamente no navegador

## Instituição
São Paulo Tech School  
Curso de Tecnologia da Informação / Análise e Desenvolvimento de Sistemas
