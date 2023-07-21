#!/usr/bin/bash

# Função para exibir uma barra de progresso
progress_bar() {
    local duration=$1
    local progress=0
    local elapsed=0
    local bar_length=40

    while [[ $elapsed -le $duration ]]; do
        ((elapsed++))
        ((progress = elapsed * bar_length / duration))

        printf "\r[%-${bar_length}s] %d%%" "$(printf '#%.0s' $(seq 1 $progress))" "$((progress * 100 / bar_length))"
        sleep 1
    done

    printf "\n"
}

# Função para exibir mensagens formatadas
textplain() {
    echo "==============================="
    echo "$1"
    echo "==============================="
    echo
}

# Função para exibir uma mensagem de erro e sair do script
exit_with_error() {
    echo "Erro: $1"
    exit 1
}

# Verifica se o script está sendo executado como root
if [[ $EUID -ne 0 ]]; then
    exit_with_error "Este script precisa ser executado como root."
fi

textplain "Instalando o VirtualBox"

wget https://download.virtualbox.org/virtualbox/7.0.8/VirtualBox-7.0.8-156879-Linux_amd64.run && chmod +x VirtualBox-7.0.8-156879-Linux_amd64.run && ./VirtualBox-7.0.8-156879-Linux_amd64.run
clear

textplain "Instalando dependências"
sleep 2

sudo apt install gcc make perl linux-headers-amd64 linux-headers-6.1.0-9-amd64 || exit_with_error "Falha ao instalar as dependências"
clear

textplain "Configurando o driver do kernel do VirtualBox"
sleep 2

clear
sudo /sbin/vboxconfig || exit_with_error "Falha ao configurar o driver do kernel do VirtualBox"
clear
sleep 2

textplain "Instalação concluída!"

# Exemplo de uso da barra de progresso
echo "Limpando a tela e finalizando a instalação..."
progress_bar 5  # Duração de 5 segundos

echo "VirtualBox foi instalado com sucesso!"
