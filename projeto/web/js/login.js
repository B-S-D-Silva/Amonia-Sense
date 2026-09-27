        function Entrar() {
            let login = input_login.value
            let senha = input_senha.value

            if (login == 'Kaua@gmail.com' && senha == '1234') {

                // TODO: criar a página "dash.html" (dashboard pós-login) e então
                // atualizar este redirecionamento. Por enquanto o link abaixo
                // aponta para um arquivo que ainda não existe no projeto.
                window.location.href = "dash.html"

            } else {
                div_mensagem.innerHTML = `Usuario Invalido`
            }


        }
