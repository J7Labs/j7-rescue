# iPhone preso após «erro desconhecido (100) 06A6.0064» — como eu o recuperei sem perder nada

> Caso real: iPhone 17 Pro Max de 256 GB, com uns 3 GB livres e **sem backup**.
> Ao atualizar para o iOS 27.2.1 pelo Mac (Finder), falhou três vezes com
> *«Não foi possível atualizar o iPhone. Ocorreu um erro desconhecido (100).
> 06A6.0064»* e ficou preso na maçã. O Finder só oferecia **Restaurar** (apagar tudo).
> Com este método ele ligou **com todos os dados**, de primeira.
>
> O conserto é do **Senne** (https://github.com/3SENN/iphone-stuck-in-recovery-full-storage).
> Este tutorial o explica em português e acrescenta uma ferramenta que faz os passos sozinha.

---

## 0. Antes de tudo: o que NÃO fazer

- ❌ **Não aperte «Restaurar»** no Finder nem no iTunes. É a única coisa que apaga os seus dados.
- ❌ Não deixe que, na loja, «o restaurem» sem perguntar a você.
- ✅ «Atualizar» e a reinicialização forçada com os botões **não apagam nada**: você pode repeti-los.

## 1. É o seu caso?

Você precisa de um Mac. Abra o **Terminal** e cole:

```bash
grep -l 'Failed preallocation due to space' ~/Library/Logs/iPhone\ Updater\ Logs/*.log
```

- **Se aparecer algum arquivo** → é exatamente este problema. Continue.
- **Se não aparecer nada** → o seu erro é outro. Este método não serve para você.

## 2. O que aconteceu (sem termos técnicos)

O iPhone é uma casa de dois andares. **Em cima fica o sistema (iOS)** e **embaixo as suas coisas**.

1. Antes de atualizar, um «guarda» confere se o sistema novo cabe. Como estava
   muito justo, ele diz «cabe».
2. O iPhone **tira o sistema antigo**.
3. Ao reservar lugar para o novo, o armazenamento aplica uma regra que o
   guarda não conhece: **não dá para reservar de uma vez mais de ~84 % do espaço livre**.
   Não entra.
4. Em cima fica vazio, e é por isso que o iPhone fica preso na maçã. **Embaixo, nada foi tocado.**

Tentar de novo pelo Finder falha sempre do mesmo jeito. O conserto **diz ao guarda que o
sistema é um pouco maior do que realmente é**. Então o guarda diz «não cabe»
e o iPhone faz a sua **faxina automática de temporários** (caches, registros…).
Com esse espaço aberto, o sistema de verdade passa a entrar.

**Risco:** a faxina pode apagar caches e coisas que são baixadas de novo.
No meu caso não faltou nada. Se falhar, o iPhone fica exatamente como estava
(em recuperação, com os dados) e dá para tentar de novo.

## 3. O que você precisa

- Um Mac com **Homebrew** (https://brew.sh) e as ferramentas do Xcode
  (`xcode-select --install`).
- Uns **20 GB livres no Mac**. Só o iOS ocupa de 11 a 14 GB. Se o Mac estiver
  se atualizando ao mesmo tempo, **cancele essa atualização**: não é necessária e consome o espaço.
- Um bom cabo, **conectado direto** ao Mac, sem hub.

## 4. Com a ferramenta (recomendado)

Guarde o `rescatar_iphone.sh` em uma pasta (por exemplo `~/RescateiPhone`) e, no Terminal:

```bash
cd ~/RescateiPhone
./rescatar_iphone.sh diagnostico
```

Se ela confirmar que é o seu caso, coloque o iPhone em **modo de recuperação**:

> Conectado ao Mac: aperte e solte **aumentar volume** → aperte e solte **diminuir volume**
> → **segure o botão lateral** (mesmo que apareça a maçã) até ver **o cabo e o computador**.
> Se o Finder abrir com «Atualizar/Restaurar», aperte **Cancelar**.

```bash
./rescatar_iphone.sh preparar
```

Isso instala e monta o programa, e baixa da Apple o iOS correto para o seu
modelo. Confere se o arquivo não está danificado e se traz a opção
«atualizar sem apagar».

```bash
./rescatar_iphone.sh rescatar
```

Calcula o número do conserto com os dados do seu iPhone, pede que você escreva
**SIM** e inicia a atualização. Enquanto isso, vai dizendo em que passo está.
**Se o programa anunciar que vai apagar, ele se interrompe sozinho.**

Se no final ele disser que ainda falta espaço, indica o comando para tentar de novo
com um número 200 maior.

## 5. O que você verá no iPhone (e não precisa se assustar)

1. **Primeira barra** (maçã + barra) enquanto o Mac envia o sistema. É aqui
   que o Finder falhava. Quando a ferramenta disser «Momento-chave superado», já passou.
2. O Mac diz **«Status: Restore Finished»**.
3. O iPhone reinicia sozinho e aparece **uma segunda barra**, lenta: ele está preparando
   os seus dados para o novo iOS. Com o iPhone muito cheio pode levar **de 10 a 30 minutos**.
   **Não toque em nada.**
4. Pede o seu código → as suas coisas estão lá. 🎉

## 6. Depois

1. **Libere de 10 a 15 GB** em Ajustes → Geral → Armazenamento do iPhone.
2. **Faça um backup** (no Mac, em um disco externo ou no iCloud).
3. Conte o seu resultado ao Senne para ajudar outras pessoas:
   https://github.com/3SENN/iphone-stuck-in-recovery-full-storage/issues/new?template=result.yml

---

## Anexo técnico (os comandos à mão)

```bash
brew install autoconf automake libtool pkgconf libimobiledevice libirecovery libtatsu libzip
git clone https://github.com/3SENN/iphone-stuck-in-recovery-full-storage.git
git clone https://github.com/libimobiledevice/idevicerestore.git
git clone https://github.com/libimobiledevice/libtatsu.git

# libtatsu nova (obrigatória no iPhone 14 e posteriores)
cd libtatsu && ./autogen.sh --prefix="$PWD/install" --enable-static --disable-shared && make -j8 && make install && cd ..

# idevicerestore com o conserto
cd idevicerestore && git checkout 60192e9
git apply ../iphone-stuck-in-recovery-full-storage/patches/0001-restore-Allow-overriding-the-declared-Cryptex1-SystemOSSize.patch
export PKG_CONFIG_PATH="$PWD/../libtatsu/install/lib/pkgconfig:$(brew --prefix)/lib/pkgconfig"
./autogen.sh --prefix="$PWD/install" && make -j8 && make install

# iPhone em recuperação: modelo e ECID
irecovery -q | grep -E 'MODE|PRODUCT|ECID'

# IPSW assinado (a MESMA versão que falhou ou uma mais nova) em https://ipsw.me
# Número do conserto usando o registro do Finder:
python3 ../iphone-stuck-in-recovery-full-storage/tools/suggest_cryptex_size.py <ipsw> \
  --log ~/Library/Logs/iPhone\ Updater\ Logs/<o que tiver o erro>.log

# Executar (NUNCA adicionar -e)
IDEVICERESTORE_CRYPTEX_SIZE_MIB=<número> caffeinate -is ./install/bin/idevicerestore \
  -y -P -i <ECID> --variant 'Customer Upgrade Install (IPSW)' <ipsw>
```

Meu caso: `iPhone18,2`, `iPhone18,2_27.2.1_24B156_Restore.ipsw`. O sistema media 6030 MiB;
eram necessários 5649 MB e havia 5676 MB livres. Funcionou com o número **6207** de primeira.
