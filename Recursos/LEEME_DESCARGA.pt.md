# J7 Rescue

**Recupere o seu iPhone sem apagar nada** quando, ao atualizá-lo pelo Mac, aparece
*«Ocorreu um erro desconhecido (100) 06A6.0064»* e ele fica preso na maçã
(quase sempre porque o armazenamento estava muito cheio).

Gratuito. Sem Terminal, sem instalar mais nada. Feito por Jesús com Claude · J7 Labs.

---

## É para mim?

Sim, se:

- Ao atualizar o iPhone com o **Finder** (Mac) apareceu o erro **(100) 06A6.0064** e agora ele só oferece «Restaurar» (que apaga tudo).
- **Não aperte «Restaurar».** É a única coisa que apaga os seus dados.

O app verifica isso por você, lendo os registros do Finder. Se o seu erro for outro, ele avisa e não continua.

## O que você precisa

- Um Mac com **chip Apple (M1 ou posterior)** e **macOS 26 (Tahoe)** ou mais novo.
- Uns **20 GB livres** no Mac (o iOS ocupa uns 13 GB).
- Um bom cabo, **conectado direto** ao Mac (sem hub).

## Download

👉 **[J7-Rescue.dmg](https://github.com/J7Labs/j7-rescue/releases/latest/download/J7-Rescue.dmg)** (uns 6 MB)

## Como abri-lo (aviso do Mac: «Abrir Mesmo Assim»)

Este app **não está na App Store** e não tem a assinatura paga da Apple, por isso o Mac
avisa na primeira vez. É normal. Para abri-lo:

1. Abra o `.dmg` e **arraste «J7 Rescue» para a pasta Aplicativos**.
2. Abra-o a partir de Aplicativos (duplo clique). Vai aparecer um aviso de que não foi possível verificar. Clique em **OK** (ou «Concluído»).
3. Abra **Ajustes do Sistema → Privacidade e Segurança**.
4. Role até a seção **Segurança**. Você verá: *«"J7 Rescue" foi bloqueado para proteger o seu Mac»*. Clique em **Abrir Mesmo Assim**.
5. Digite a senha do seu Mac (ou use o Touch ID) e clique em **Abrir**.

Só é preciso na primeira vez. Depois ele abre como qualquer outro app.

> Prefere não confiar em um arquivo que você baixa da internet? Faz bem em se perguntar isso.
> Todo o código (do app e do que ele leva dentro) está na pasta `CODIGO_FUENTE`
> do `.dmg`, e o conserto em que ele se baseia é público (link abaixo).

## Como usar

1. Abra o app. Ele verifica sozinho se o seu caso é este.
2. Coloque o iPhone em **modo de recuperação** (o app mostra com um desenho): aumentar volume · diminuir volume · segurar o botão lateral até ver o cabo e o computador.
3. Clique em **Baixar o iOS** (ele baixa direto da Apple; se a conexão cair, continua de onde parou).
4. Clique em **Resgatar meu iPhone**, escreva **SIM** e espere. **Não toque no iPhone nem no cabo.**
5. Quando o Mac terminar, o iPhone liga sozinho com uma barra lenta (10 a 30 min). Quando pedir o código, as suas coisas estão lá.

O app avisa você com uma notificação quando o download terminar, quando passar o «momento-chave» e quando acabar.

## É seguro porque…

- **Nunca apaga**: usa sempre a opção «atualizar» e, se o programa anunciar que vai apagar, ele se interrompe sozinho.
- Pede que você escreva **SIM** antes de começar.
- O iOS é baixado **somente de servidores da Apple** e é verificado para garantir que não está danificado.
- Se algo falhar, o iPhone fica como estava (em recuperação, com os seus dados) e dá para tentar de novo.

> Ainda assim, nenhum método é 100 % infalível. Se puder, faça um backup quando terminar.
> O app é oferecido **como está, sem garantia**.

## Créditos

- **Senne (3SENN)** — criador do conserto que torna tudo isso possível: https://github.com/3SENN/iphone-stuck-in-recovery-full-storage
- **Igor Varyvoda** — o guia dele explicou o problema e deu o código de erro (06A6.0064) que nos levou ao conserto do Senne: https://www.varyvoda.com/posts/iphone-error-100-full-storage-without-erasing/
- **A equipe do libimobiledevice** (Nikias Bassen, Martin Szulecki, Joshua Hill e todas as pessoas que contribuíram) — idevicerestore e as bibliotecas base: https://libimobiledevice.org
- **Feito por Jesús com Claude** · J7 Labs

## Licenças e código-fonte

O código original do «J7 Rescue» tem **licença MIT** (gratuito, pode ser copiado e modificado, sem garantia). O restante pertence aos seus autores, com as suas licenças:

O J7 Rescue usa software livre: idevicerestore (LGPL 2.1 ou posterior, com o patch do Senne, domínio público CC0),
libirecovery, libimobiledevice, libusbmuxd, libimobiledevice-glue, libplist e libtatsu (LGPL 2.1),
OpenSSL (Apache 2.0), libzip (BSD), xz e zstd (BSD / domínio público).
As bibliotecas vão como arquivos separados dentro do app (`Contents/Frameworks`), então podem ser substituídas.
O `.dmg` inclui as pastas **`Licencias`** (textos completos) e **`CODIGO_FUENTE`** (código exato, patch e como reconstruí-lo).
Código original: https://github.com/libimobiledevice · https://github.com/3SENN/iphone-stuck-in-recovery-full-storage

«iPhone», «iOS», «Finder» e «Apple» são marcas da Apple Inc. Este app não é da Apple nem é endossado pela Apple.
