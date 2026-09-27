# 🐄 Amônia Sense

### Sistema de Detecção de Vazamentos de Amônia em Frigoríficos Bovinos

Protótipo de IoT para monitoramento em tempo real de vazamentos de gás amônia (NH₃) em ambientes de refrigeração industrial de carne bovina.

---

## 📌 Sobre o Projeto

A amônia é amplamente usada como fluido refrigerante em câmaras frias de frigoríficos por ser eficiente e barata — mas também é tóxica e, em concentrações elevadas, coloca em risco a saúde dos trabalhadores e a integridade do produto armazenado.

Este repositório contém o código-fonte e a documentação técnica de um protótipo que:

- **Lê** a concentração de NH₃ no ar por meio do sensor **MQ-2**, conectado a um microcontrolador Arduino;
- **Aciona** um alarme sonoro e visual localmente, na própria bancada, caso o nível detectado ultrapasse o limite seguro;
- **Registra** cada leitura em um banco de dados relacional (MySQL), com data e hora;
- **Exibe** o histórico e os níveis de gás em um painel web, com gráficos e ferramentas de simulação de impacto financeiro de um eventual vazamento.

## ⚙️ Como Funciona

```
 Sensor MQ-2  ──►  Arduino (main.ino)  ──►  Banco de Dados (MySQL)  ──►  Painel Web
     │                    │
     │                    └──► Alarme sonoro/visual local (imediato)
     └──► Leitura analógica contínua da concentração de NH₃
```

## 🗂️ Estrutura do Repositório

```
Amonia-Sense/
├── arduino/
│   └── main.ino              # Código C/C++ do microcontrolador e leitura do sensor MQ-2
│
├── banco-de-dados/
│   └── tabelas.sql           # Script de criação das tabelas (MySQL)
│
├── projeto/
│   └── web/                  # Painel web
│       ├── index.html            # Página inicial
│       ├── pagina-login.html     # Login
│       ├── pagina-cadastro.html  # Cadastro de novo usuário
│       ├── calculadora.html      # Simulador de custos/impacto de um vazamento
│       ├── css/                  # Estilos de cada página
│       ├── js/                   # Lógica de front-end (login, cadastro, cálculos)
│       └── img/                  # Imagens e logo
│
└── README.md
```

## 🧰 Tecnologias Utilizadas

| Camada | Tecnologia |
|---|---|
| **Hardware** | Arduino (Uno R3) + Sensor de Gás MQ-2 |
| **Banco de Dados** | MySQL |
| **Front-end** | HTML5, CSS3, JavaScript |

## ✅ Funcionalidades do Protótipo

- [x] **Coleta de dados** — leitura contínua do pino analógico do sensor MQ-2
- [x] **Alerta local** — alarme sonoro e sinalização visual na bancada em caso de anomalia
- [x] **Persistência de dados** — registro histórico das leituras no MySQL, com data e hora
- [x] **Painel web** — cadastro/login de usuários e simulador de custos de um incidente
- [ ] **Gráficos em tempo real** — visualização da variação dos níveis de gás em gráfico de linha *(em desenvolvimento)*

## 🚀 Como Executar

### Painel web
1. Baixe ou clone este repositório.
2. Abra a pasta `projeto/web/`.
3. Abra o arquivo `index.html` diretamente no navegador.

> Nenhum servidor é necessário para navegar entre as páginas — os caminhos são todos relativos à pasta `web/`.

### Banco de dados
1. Crie um banco no MySQL e execute o script `banco-de-dados/tabelas.sql` para gerar as tabelas.

### Arduino
1. Abra `arduino/main.ino` na IDE do Arduino.
2. Conecte o sensor MQ-2 ao microcontrolador conforme a pinagem definida no código.
3. Faça o upload do sketch para a placa.

## 🎓 Instituição

**São Paulo Tech School**
Curso de Tecnologia da Informação / Análise e Desenvolvimento de Sistemas

## 👥 Integrantes

- Laura de Araujo
- Bruno Santos
- Kauã Andrade
- Gustavo de Jesus
- Marcus Vinicius
- Pedro Gabriel