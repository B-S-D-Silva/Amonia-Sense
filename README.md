# AmoniaSense

Protótipo acadêmico de monitoramento de vazamentos de amônia em frigoríficos bovinos. O projeto reúne uma interface web, scripts SQL e uma API para aquisição de dados com Arduino.

> **Nota sobre o sensor:** o protótipo utiliza o MQ-2 para simulação didática. Para detecção industrial de amônia (NH₃), devem ser usados sensores específicos, como MQ-137, ou detectores eletroquímicos homologados.

## Visualizar as páginas

Depois que o GitHub Pages for habilitado e o workflow concluir a publicação, cada tela poderá ser acessada diretamente:

| Página | Acesso |
| --- | --- |
| Início | [AmoniaSense](https://b-s-d-silva.github.io/Amonia-Sense/projeto/web/index.html) |
| Simulador financeiro | [Calculadora](https://b-s-d-silva.github.io/Amonia-Sense/projeto/web/calculadora.html) |
| Login | [Entrar](https://b-s-d-silva.github.io/Amonia-Sense/projeto/web/pagina-login.html) |
| Cadastro | [Criar conta](https://b-s-d-silva.github.io/Amonia-Sense/projeto/web/pagina-cadastro.html) |

O site é estático: login e cadastro são demonstrações de interface e não salvam contas nem autenticam usuários em um servidor. A publicação é feita automaticamente pelo GitHub Actions a partir da pasta `projeto/web` sempre que há um push na branch `main`.

Para habilitar a publicação no repositório, abra **Settings > Pages** e selecione **GitHub Actions** como origem. Depois que o workflow terminar, os links acima estarão disponíveis. Também é possível executar o workflow manualmente na aba **Actions**.

## Estrutura do repositório

- [`projeto/web/`](projeto/web/) — páginas HTML, estilos e imagens da interface.
- [`banco-de-dados/`](banco-de-dados/) — diagramas e scripts de criação do banco MySQL.
- [`apiDataquino/dat-acqu-ino/`](apiDataquino/dat-acqu-ino/) — API Node.js para aquisição de dados.

## Tecnologias

- **Interface:** HTML, CSS e JavaScript.
- **Aquisição de dados:** Arduino e sensor MQ-2 (protótipo).
- **Banco de dados:** MySQL.
- **API:** Node.js.

## Executar a interface localmente

Abra `projeto/web/index.html` no navegador. Para navegar pelas demais telas, use os links do menu ou abra `calculadora.html`, `pagina-login.html` e `pagina-cadastro.html` na mesma pasta.

## Banco de dados

Os scripts SQL estão na pasta [`banco-de-dados/`](banco-de-dados/). Revise o conteúdo do script desejado antes de executá-lo no MySQL.

## API de aquisição de dados

Consulte as instruções específicas em [`apiDataquino/dat-acqu-ino/README.md`](apiDataquino/dat-acqu-ino/README.md). A API precisa ser executada localmente e configurada com as credenciais do banco; ela não é hospedada pelo GitHub Pages.

## Instituição

São Paulo Tech School  
Curso de Tecnologia da Informação / Análise e Desenvolvimento de Sistemas
