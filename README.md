<img width="1024" height="572" alt="imagemgit" src="https://github.com/user-attachments/assets/7620abec-0f9c-42e8-b35f-4c1c2a63e79d" />

## AmoniaSense

Protótipo acadêmico de Internet das Coisas (IoT) para apoiar o monitoramento de vazamentos de amônia em ambientes de refrigeração industrial de frigoríficos bovinos. A proposta combina sensores, aquisição de dados, armazenamento e visualização para ajudar a identificar situações que exigem atenção.

> **Importante — uso didático:** o protótipo utiliza o sensor analógico MQ-2 como representação de leitura de gases. Ele não é um detector seletivo nem homologado para medir amônia em aplicações industriais. Uma instalação real deve usar sensores específicos para NH₃, como MQ-137, ou detectores eletroquímicos certificados, além de seguir as normas e orientações de segurança aplicáveis.

## Acessar a interface

As telas web podem ser abertas individualmente:

| Página | Acesso |
| --- | --- |
| Página inicial | [AmoniaSense](https://b-s-d-silva.github.io/Amonia-Sense/web-data-viz-main/web-data-viz-main/public/index.html) |
| Simulador financeiro | [Calculadora](https://b-s-d-silva.github.io/Amonia-Sense/web-data-viz-main/web-data-viz-main/public/calculadora.html) |
| Login demonstrativo | [Entrar](https://b-s-d-silva.github.io/Amonia-Sense/web-data-viz-main/web-data-viz-main/public/pagina-login.html) |
| Cadastro demonstrativo | [Criar conta](https://b-s-d-silva.github.io/Amonia-Sense/web-data-viz-main/web-data-viz-main/public/pagina-cadastro.html) |

A interface estática é publicada pelo GitHub Pages a partir de `projeto/web`. A publicação é automatizada pelo GitHub Actions quando há atualização na branch `main`. As páginas de login e cadastro são apenas demonstrações visuais: não criam contas, não autenticam usuários e não armazenam os dados enviados.

## O que o protótipo propõe

- **Leitura de gás:** aquisição periódica dos valores analógicos enviados pelo sensor conectado ao Arduino.
- **Sinalização de anomalias:** indicação de condições de atenção e, na montagem física proposta, possibilidade de acionar alarme sonoro e sinalização visual local.
- **Histórico:** armazenamento das leituras com data e hora em banco de dados relacional.
- **Visualização:** acompanhamento dos valores e dos alertas em uma interface web.
- **Simulador financeiro:** estimativas de perdas por paralisação, custo de implementação de sensores e passivo trabalhista.

As telas do site e a API são componentes separados. A publicação no GitHub Pages hospeda somente arquivos estáticos; ela não executa a API Node.js, acessa portas seriais ou conecta ao MySQL.

## Componentes do repositório

| Caminho | Conteúdo |
| --- | --- |
| [`projeto/web/`](projeto/web/) | Site em HTML, CSS e JavaScript: página inicial, simulador financeiro, login e cadastro demonstrativos, além de imagens e estilos. |
| [`apiDataquino/dat-acqu-ino/`](apiDataquino/dat-acqu-ino/) | API Node.js/Express para ler dados pela porta serial do Arduino e disponibilizar leituras em JSON. |
| [`banco-de-dados/`](banco-de-dados/) | Diagrama MySQL e duas versões de scripts SQL para modelagem de clientes/empresas, locais, sensores, leituras e incidentes. |
| [`.github/workflows/pages.yml`](.github/workflows/pages.yml) | Workflow de publicação do site no GitHub Pages. |

**Observação sobre o hardware:** não há atualmente um sketch Arduino (`.ino`) neste repositório. O código da API pressupõe que o dispositivo envie leituras pela serial; o firmware e a montagem física precisam ser preparados separadamente.

## Como executar localmente

### Interface web

1. Clone o repositório:

   ```bash
   git clone https://github.com/B-S-D-Silva/Amonia-Sense.git
   cd Amonia-Sense
   ```

2. Abra `projeto/web/index.html` no navegador. A navegação do site permite acessar o simulador, o login e o cadastro. Também é possível abrir diretamente os outros arquivos `.html` da pasta.

### API de aquisição serial

Pré-requisitos: Node.js, Arduino conectado e configurado para transmitir dados pela serial, e opcionalmente um servidor MySQL.

1. Entre na pasta da API e instale as dependências:

   ```bash
   cd apiDataquino/dat-acqu-ino
   npm install
   ```

2. Configure a porta serial pela variável `ARDUINO_PORT` ou passe o caminho da porta como argumento. A API procura também um dispositivo Arduino compatível. A comunicação serial está configurada para **9600 baud**.

3. Inicie o serviço:

   ```bash
   npm start
   ```

4. Com a API em execução, consulte as leituras em [`http://localhost:3300/sensores/gas`](http://localhost:3300/sensores/gas). Para encerrar, use `Ctrl+C` no terminal.

O código recebe valores separados por linha e mantém as leituras em memória enquanto o processo está ativo. A gravação no MySQL está desabilitada por padrão. Para habilitá-la, é necessário configurar as credenciais localmente e adaptar o `INSERT` à tabela e ao esquema escolhidos. **Não versione credenciais reais.** Os scripts SQL incluídos têm estruturas diferentes e não criam automaticamente a tabela `medida` esperada pelo exemplo atual da API.

### Banco de dados

Os arquivos [`banco-de-dados/tabelas.sql`](banco-de-dados/tabelas.sql) e [`banco-de-dados/tabelas_v2.sql`](banco-de-dados/tabelas_v2.sql) representam versões distintas do modelo. Revise e escolha a versão adequada antes de executar. Em especial, `tabelas.sql` começa com `DROP DATABASE IF EXISTS amonia_sense`, removendo o banco com esse nome e seus dados antes de recriá-lo. Faça backup e confirme o banco selecionado antes de executar qualquer script.

## Tecnologias

- **Interface:** HTML5, CSS3 e JavaScript.
- **Aquisição serial:** Node.js, Express e SerialPort.
- **Persistência prevista:** MySQL, com biblioteca `mysql2` na API.
- **Hardware do protótipo didático:** Arduino e sensor MQ-2.
- **Hospedagem das páginas estáticas:** GitHub Pages e GitHub Actions.

## Instituição

São Paulo Tech School (SPTech)<br>
Curso de Tecnologia da Informação / Análise e Desenvolvimento de Sistemas
