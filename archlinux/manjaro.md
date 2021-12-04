# Manjaro

<!--Este é um arquivo Markdown, então abra-o utilizando o software chamado **GhostWriter** para melhor visualização.-->

Considere ler este tutorial e confira assim as dicas do seu sobrinho lindo para utilizar este sistema operacional sem problemas!

## Referências

- Artigo utilizado como referência para configuração do Virtual Machine Manager: [Installing KVM/QEMU/virt-manager on Manjaro Linux(Arch Linux)](https://boseji.com/posts/manjaro-kvm-virtmanager/).

- Artigo utilizado como referência para configuração dos gestos do touchpad: [How to enable touchpad gestures on Manjaro (works on all Arch based distros)](https://www.youtube.com/watch?v=suPJmIm-tNI).

## Informações do sistema

- Sistema de arquivos
    > BTRFS

- Kernel
    > Linux 5.10.56-1
    <!--
    > Linux 5.6.15-1
    -->

- Distro baseada
    > ArchLinux

- Gerenciadores de pacotes
    > Pamac e **Pacman (Package Manager)**
    
- Interface gráfica
    > KDE Plasma 5
    
- Ciclo de desenvolvimento do sistema operacional
    > Rolling release (não existe versionamento, o usuário sempre está na última versão)

## Manutenção do sistema

- Abrir o terminal
    > Há duas opções nativas do sistema: Konsole (CTRL+ALT+T) e **Yakuake** (F12).

- Cancelar a execução de um comando no terminal
    > Aperte CTRL+C

- Testar conexão de internet pelo terminal (caso necessário)
    > $ `ping -c 3 archlinux.org`

### Backups

Para fazer/restaurar um backup do sistema utilize o Timeshift, pois a interface gráfica é bem simples e objetiva e um ótimo desempenho (tanto em velocidade quanto em economia de espaço em disco). Com este software é possível até agendar backups diários/semanais, caso prefira. Sugiro sempre realizar um backup do sistema antes de fazer alguma modificação mais agressiva no sistema, como por exemplo, ao instalar um software desconhecido ou editar configurações do sistema.

### Atualização

Procure atualizar o sistema operacional e os softwares ao menos uma vez por semana.

- Atualizar a lista de links dos repositórios (usar apenas em caso de problemas na atualização do sistema)
    > $ `sudo pacman-mirrors -f`
    
- Atualizar repositórios
    > $ `sudo pacman -Syy`

- Atualizar systema
    > $ `sudo pacman -Syyuu`
    
- Caso não queria responder com 'yes' ou 'no' as perguntas, adicione a flag no final do comando
    > $ `--noconfirm`

### Gerenciar softwares

Neste tópico abordo sobre os gerenciadores de pacotes nativos presentes no Manjaro. É possível instalar mais gerenciadores de pacotes adicionais, tais como o Flatpak e o Snap.

Um breve resumo sobre os gerenciadores de pacotes

#### ArchLinux

- Pacman
    > É o APT (Advanced Package Tool) do lado ArchLinux da força! Caso algum problema acontecer no sistema, tenha em mente que é este o cara que vai resolver.

- Pamac
    > Uma interface gráfica (é possível utilizar sem interface gráfica também) para fazer o que o Pacman faz.

- Paru
    > É o Pacman dos repositórios da comunidade.

##### Pacman

O Pacman é o melhor, mais completo, mais estável e mais rápido gerenciador de pacotes que existe. Aprenda a utilizá-lo porque vale muito a pena.

- Pesquisar se um determinado programa está instalado no sistema
    > $ `sudo pacman -Q <nome_programa>`, por exemplo: $ `sudo pacman -Q timeshift`

- Listar todos os programas instalados no sistema
    > $ `sudo pacman -Ql`, mas se quiser filtrar, use o comando Grep: $ `sudo pacman -Ql | grep "<digite aqui o termo que procura>"`

- Pesquisar um programa
    > $ `sudo pacman -Ss <nome_programa>`, por exemplo: $ `sudo pacman -Ss timeshift`
    
- Instalar um programa
    > $ `sudo pacman -S <nome_programa>`, por exemplo: $ `sudo pacman -S timeshift`

- Desinstar um software
    > $ `sudo pacman -R <nome_programa>`, por exemplo: $ `sudo pacman -R timeshift`

- Desinstar um software e as dependencias dele que não serão mais necessárias **(comando recomendado)**
    > $ `sudo pacman -Rns <nome_programa>`, por exemplo: $ `sudo pacman -Rns timeshift`

##### Pamac

O Pamac é um gerenciador de pacotes que não vale a pena utilizar pelo terminal, porém é útil caso prefira gerenciar o sistema através de uma interface gráfica.

##### Paru

Antes de falar sobre o Paru propriamente dito é necessário entender um conceito muito importante. Como o ArchLinux (que é o sistema base do Manjaro) é desenvolvido pela comunidade qualquer um poderia injetar códigos maliciosos nos pacotes de instalação de programas. Tendo isto em mente, surgiu uma solução bem interessante, a divisão dos repositórios em: **ArchLinux (oficial)** e **ArchLinux User Repository (AUR)**.

- O repositório oficial tem os softwares analisados pelos mantenedores do ArchLinux antes de serem disponibilizados nos servidores.

- O reposítorio da comunidade (AUR) vem desabilitado por padrão. Neste repositório qualquer um pode criar um conta e subir o conteúdo, inclusive os desenvolvedores oficiais do programa. O interessante deste método é que não é feito o upload do pacote em si (assim como o **.exe** do Windows, o **.deb** do Debian/Ubuntu ou o **.rpm** do Fedora/RedHat), mas um único script contendo as instruções para baixar o o código fonte do programa, compilar e então instalá-lo no sistema, incluindo as dependencias. Como o programa vai ser compilado seguindo as configurações da máquina do usuário, o desempenho deste software é superior quando executado. A complexidade deste método acabaria sendo bem alta para quem não sabe como fazer isto manualmente, mas é justamente aí que entra o tal do **Paru** (há alternativas, tal como o Yaourt e o YAY).

O **Paru** vai utilizar a mesma síntaxe do Pacman para gerenciar os softwares do AUR. O Pacman, por questões de segurança não acessa o AUR justamente para o usuário poder diferenciar a origem de cada software e também não quebrar o gerenciamento do sistema. A seguir os comandos do **Paru**

- Pesquisar se um determinado programa está instalado no sistema
    > $ `paru -Q <nome_programa>`, por exemplo: $ `paru -Q timeshift`

- Listar todos os programas instalados no sistema
    > $ `paru -Ql`, mas se quiser filtrar, use o comando Grep: $ `paru -Ql | grep "<digite aqui o termo que procura>"`

- Pesquisar um programa
    > $ `paru -Ss <nome_programa>`, por exemplo: $ `paru -Ss timeshift`
    
- Instalar um programa
    > $ `paru -S <nome_programa>`, por exemplo: $ `paru -S timeshift`

- Desinstar um software
    > $ `paru -R <nome_programa>`, por exemplo: $ `paru -R timeshift`

- Desinstar um software e as dependencias dele que não serão mais necessárias **(comando recomendado)**
    > $ `paru -Rns <nome_programa>`, por exemplo: $ `paru -Rns timeshift`

#### Universal

Diante da fragmentação das distros Linux, onde cada sistema operacional usava (e ainda usa) um tipo de pacotes diferente, para os desenvolvedores surgiu a necessidade de um método que um vez empacotado o software funcionaria em qualquer distro Linux.

##### AppImage
    > Um formato de pacote universal para ambientes Linux que não requerem a instalação do software (similar aos programas portáteis do Windows). Não é necessário instalar nenhum programa adicional para usar um AppImage, apenas dar permissão de execução. Para pesquisar um arquvio AppImage verifique neste site: [AppImage](https://www.appimagehub.com/)
    
##### Flatpak
    > Desenvolvido pela Red Hat para ser um formato de pacotes universal no ambiente Linux. O mesmo pacote em Flatpak pode ser instalado em sistemas baseados em ArchLinux, Debian/Ubuntu, Fedora/RedHat, Gentoo, Suse, etc. Para usar o Flatpak é necessário instalar no sistema operacional através do comando: $ `sudo pacman -S flatpak`. É necessário reiniciar a sessão de usuário para aplicar as configurações.

##### Snap
    > Mesma coisa que o Flatpak, entretanto é desenvolvido e mantido pela Canonical (a empresa por trás do Ubuntu). Para usar o Snap é necessário instalar no sistema operacional através dos comandos: $ `sudo pacman -S snapd` e $ `sudo systemctl enable --now snapd.socket`. É necessário reiniciar a sessão de usuário para aplicar as configurações.
    
## Customização desnecessária

Apenas dois comandos simples e inofencivos para você "brincar".

- Exibir o efeito do Matrix no terminal
    > $ `cmatrix`
    
- Exibir as informações do sistema operacional do jeito topizera da balada que você gostou
    > $ `neofetch`

## Máquina virtual

A virtualização é um recurso suportado e optimizado pelo kernel Linux através do KVM.

- O **KVM** suporta a virtualização de hardware para fornecer desempenho quase nativo aos sistemas operacionais virtualizados.

- O **QEMU** emula o sistema operacional.

- O **Virtual Machine Manager** é uma interface gráfica para o QEMU.

- Boas práticas
    > Ao término da instalação de uma máquina virtual, considere _clonar_ a máquina. Utilize a máquina para realizar seus testes. Caso algo de errado aconteça com o sistema, basta apagar a _máquina clonada_ e realizar uma nova clonagem. Desta forma não será realizar todo o processo de instalação do sistema operacional do início.

## Alterações no sistema operacional

Relatório das alterações realizadas no sistema operacional Manjaro.

- Arquivos
    - [x] Backup do sistema

- Customização
    - [x] Alteração da imagem de usuário
    - [x] Alteração do wallpaper
    - [x] Inversão do eixo vertical do touchpad
    - [x] Simplificação do Application Launcher (menu iniciar)
    - [x] Desabitar a opção _Ctrl+Tab cycles through tabs in recently used order_ no Firefox
    - [x] Atualização do sistema operacional e de todos os softwares do sistema
    - [x] Forçar janelas dos programas ficarem centralizadas ao abrir
    - [ ] Alterar o tema do sistema para Dracula

- Softwares (máquina hospedeira)
    1. [x] Base-devel (compiladores de softwares)
    1. [x] Cheese
    1. [x] CMatrix
    1. [x] Firejail
    1. [x] Gestures
    1. [x] Google Chrome
    1. [x] GParted
    1. [x] LF (file manager from terminal)
    1. [x] MPV Media Player
    1. [x] Neofetch
    1. [x] Paru
    1. [x] Redshift
    1. [x] Timeshift
    1. [x] Vim
    1. [x] Virt-Manager
    1. [x] Zoom
    1. [ ] Drives de Bluetooth

- Softwares (máquina virtual - Windows 10)
    1. [ ] Pacote Office
    1. [ ] Pacote Affinity
    1. [ ] 
    1. [ ] 

- Máquinas virtuais
    1. [x] Fedora 34
    1. [x] Windows 10

## Testes

Lista de testes realizados separados por categorias

- Drivers
    1. [ ] Reconhecimento de Bluetooth
    1. [x] Reconhecimento de execução de vídeos
    1. [ ] Reconhecimento de impressora
    1. [x] Reconhecimento de gestos pelo touchpad
    1. [x] Reconhecimento de pendrives
    1. [x] Reconhecimento de webcam
    
- Máquina virtual
    1. [x] Reconhecimento de conexão com a internet na máquina virtualizada.
    1. [ ] Reconhecimento de portas USB pela máquina virtual
    1. [ ] Transferencia de arquivos entre a máquina hospedeira e a virtualizada.

## Código fonte

Assim que terminei de instalar e configurar o sistema operacional, escrevi um script para facilitar o uso caso precise reinstalar o sistema por completo até este o momento. Lembrando sempre que há ainda os backups do sistema realizado pelo **Timeshift**.

O motivo deste script ser escrito é para caso você decida instalar o Windows novamente e apague o sistema operacional Manjaro deste computador. E, caso não consiga realizar esta tarefas, para que fique chupando o dedo, este script vai te ajudar a restaurar o trabalho que aqui realizei. Lembrando que algumas configurações sútis deverão ser feitas manualmente.

O arquivo `script.sh` encontra-se no mesmo diretório que esta documentação.