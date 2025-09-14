Instrukcja konfiguracji wielozadaniowego i rozszerzalnego środowiska developerskiego w WSL

Jest to moja konfiguracja z którą żyję i pracuję od ponad 2 lat. Osoby doświadczone mogą ją dostosować pod siebie 😜

# Czego potrzebujemy?

- [WSL](https://learn.microsoft.com/en-us/windows/wsl/install)
- [Windows Terminal](https://learn.microsoft.com/en-us/windows/terminal/install)
- jakieś IDE (ja używam [VSCode](https://code.visualstudio.com/))

> [!NOTE]
> Jeśli pracujesz na MacOS/Linuxie WSL i Windows Terminal nie są Ci potrzebne, domyślnie zaczniesz z Bashem, więc możesz pominąć tą część i zacząć od instalowania Zsh.
> Może się też okazać, że WSL i Windows Terminal zostały zainstalowane domyślnie razem z Windowsem, wtedy też po prostu przejdź dalej :)

> [!TIP]
> Instalując WSLa przez `wsl --install [Distro]` nie możemy zmienić nazwy ani lokalizacji gdzie WSL zostanie zainstalowany. Jeśli zależy Ci na instalacji WSLa w konkretnym katalogu: 
> - zainstaluj interesujące Cię distro
> - wyeksportuje je do pliku `.tar` komendą `wsl --export [Distro] [C:/distro_path.tar]`
> - zaimportuj distro z pliku `wsl --import [Nowa nazwa] [Docelowa lokalizacja] [C:/distro_path.tar]`
>
> Jeśli potrzebujesz mieć kilka odseparowanych od siebie środowisk, możesz wykonać import wiele razy z różnymi nazwami i lokalizacjami

# Co chcemy osiągnąć?

Celem jest przygotowanie środowiska, które będzie przystosowane do pracy z wieloma językami programowania (ja pracowałem na nim głównie w ekosystemie [Node.js](https://nodejs.org/)/[Python](https://www.python.org/)). Zależy nam też na dobrym Developer Experience by w łatwy sposób upraszczać sobie codzienne czynności lub całkowicie delegować myślenie o niektórych rzeczach.

Docelowy stack:
- [Zsh](https://www.zsh.org/) & [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH) - alternatywna powłoka dla Basha
- [powerlevel10k](https://github.com/romkatv/powerlevel10k) - motyw dla Zsh, dodający kilka przydatnych informacji do linii poleceń (obecnie już nie rozwijany, ale nadal dobrze działający)
- [asdf](https://asdf-vm.com/) - CLI tool do zarządzania wersjami zależności jak Node.js/Python (zapewnia kompatybilność z narzędziami typowymi dla poszczególnych ekosystemów jak `nvm`)
- [zsh-autoenv](https://github.com/Tarrasch/zsh-autoenv) - narzędzie pozwalające na konfigurację dowolnych skryptów podczas wchodzenia/opuszczania katalogu

# Setup krok po kroku

- Otwórz Windows terminal i zainstaluj/zaimportuj interesujące Cię distro (w moim przypadku będzie to `Ubuntu`)
- Wykonaj (ta komenda zaktualizuje zależności i zainstaluje kilka paczek których mogą oczekiwać inne narzędzia): 
    ```bash
    sudo apt update; sudo apt install make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl git \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    ```
- Zainstaluj zsh komendą: `sudo apt install git curl zsh`
- Zainstaluj `Oh My Zsh` komendą: `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- Zainstaluj motyw `powerlevel10k` komendą `git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"`

> [!TIP]
> Przed konfiguracją `powerlevel10k` warto pobrać i zainstalować którąś z czcionek [Nerd Fonts](https://www.nerdfonts.com/font-downloads). Ja zgodnie z rekomendacją użyję `Meslo Nerd Font`. Instrukcję znajdziesz [tutaj](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#manual-font-installation). Po instalacji należy ją wybrać w Windows Terminalu)
- Otwórz plik `~/.zshrc` (jeśli używasz VSCode możesz wewnątrz terminala wpisać `code ~/.zshrc`) i zmień wartość zmiennej `ZSH_THEME` na `powerlevel10k/powerlevel10k`
- Wpisz `exec zsh` aby przeładować terminal i przejść do konfiguracji motywu (jeśli konfiguracja sama się nie zacznie wpisz `p10k configure`)
- Przejdź przez konfigurację (przy pytaniu o `Instant prompt` sugeruję odpowiedzieć tak, reszta według uznania)
- Zainstaluj `asdf`
-   - Najprostszą metodą na Ubuntu będzie pobranie binarek i rozpakowanie ich komendami (w razie potrzeby podmień wersję):
        ```bash
        export ASDF_VERSION="0.18.0"
        curl -LO "https://github.com/asdf-vm/asdf/releases/download/v${ASDF_VERSION}/asdf-v${ASDF_VERSION}-linux-amd64.tar.gz"
        sudo tar -xzf "asdf-v${ASDF_VERSION}-linux-amd64.tar.gz" -C /usr/local/bin
        ```
> [!NOTE]
> Jeśli korzystasz z Package Menagera który wspiera `asdf`, skorzystaj z niego zgodnie z [instrukcją](https://asdf-vm.com/guide/getting-started.html)

-  - (Opcjonalnie) Dodaj poniższe linijki na końcu swojego pliku `.zshrc`. Sprawią one, że terminal będzie podpowiadać składnię:
        ```bash
        export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
        mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
        asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
        fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
        autoload -Uz compinit && compinit
        ```
> [!WARNING]
> Wiele poradników sugeruje dodanie `asdf` do listy pluginów w `~/.zshrc`, jednak ten plugin nie działa poprawnie z nowszymi wersjami `asdf` więc NIE należy go tam dodawać

-   - Zainstaluj interesujący Cię plugin (dla przykładu `nodejs`): `asdf plugin add nodejs`
-   - Zainstaluj interesującą Cię wersję zależności (w przykładzie `latest`): `asdf install nodejs latest`
-   - (Opcjonalnie) Jeśli będziesz uruchamiał projekty które mają pliki wersji z innych narzędzi jak na przykład `.nvmrc`/`.node-version` wywołaj `"legacy_version_file = yes" > ~/.asdfrc`. Stworzy to plik konfiguracyjny dla `asdf` i włączy wsparcie dla innych plików niż `.tool-version`
- Zainstaluj `autoenv` komendami:
    ```bash
    git clone https://github.com/Tarrasch/zsh-autoenv ~/.dotfiles/lib/zsh-autoenv
    echo 'source ~/.dotfiles/lib/zsh-autoenv/autoenv.zsh' >> ~/.zshrc
    ```
- (Opcjonalne) wygeneruj klucze SSH. Jeśli pracujesz z gitem jest to zdecydowanie wygodniejsza forma komunikacji niż za pomocą `https` 

I to z grubsza tyle :) Można zacząć kodować. Poniżej jeszcze kilka dodatkowych uwag i podpowiedzi jak dostosować środowisko by przyjemnie się z nim pracowało.

> [!IMPORTANT]
> Gdy będziesz już zadowolony ze swojej konfiguracji koniecznie zrób backup (`wsl --export [Distro] [ścieżka.tar]` w PowerShellu). Jeśli nie chcesz by Twoje wysiłki przy konfiguracji przepadły z wymianą sprzętu warto mieć kopię środowiska na nośniku zewnętrznym. Export przydaje się również jeśli pracujesz na kilku fizycznych maszynach i chcesz mieć na nich spójne środowiska (klucze wygenerowane wewnątrz WSLa są częścią exportu, więc dostępy po SSH też będą takie same)

### Programy Windowsa dostępne w WSL

Wewnątrz WSLa możesz korzystać z niektórych programów dostępnych na Windowsie. Możesz w ten sposób np otworzyć obecną lokację w eksploratorze plików za pomocą `explorer.exe .`.

Część programów ma też natywną integrację w WSLem, np:
- Windows Terminal automatycznie dodaje nowe profile podczas instalowania/importowania nowego distro
- VSCode pozwala bez dodatkowej konfiguracji otwierać pliki w WSLu. Warto jednak zainstalować [dedykowaną wtyczkę](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) dzięki której łatwiej zarządzać oboma środowiskami.
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) po zainstalowaniu na Windowsie pozwala na korzystanie z Dockera wewnątrz WSLa.

### Spójne pliki między Windowsem i WSL

Jeśli chcesz mieć spójność pomiędzy Windowsem i WSL dla takich plików jak klucze SSH, autoryzacja konfiguracja azure/aws itp. Możesz wewnątrz WSLa utworzyć linki symboliczne do plików Windowsa. Cały Windowsowy system plików jest dostępny w `mnt/{Litera partycji}` (dla przykładu Windowsowy `C:\some_dir`, w WSLu będzie dostępny pod `mnt/c/some_dir`).

> [!TIP]
> W większości przypadków kod lepiej trzymać w WSLu i w razie potrzeby otwierać explorerem, niż trzymać na Windowsie i linkować do WSLa. Jest to związane z implementacją systemu plików, który w Unixach zwykle pozwala na lepszy performance.

### Aliasy

Jeśli podczas pracy często korzystasz z jakiejś sekwencji komend, podczas wpisywanie komend robisz literówki, albo często używasz jakiegoś pliku/katalogu i zapominasz gdzie on jest, to w takich sytuacjach warto wspomóc się aliasami. W pliku `.zshrc` jest sekcja z przykładami aliasów które można po prostu odkomentować, dopisać własne, lub zgodnie z sugestią w pliku zdefiniować je w osobnym pliku `$ZSH_CUSTOM/aliases.zsh` (wtedy również łatwiej je przenosić między maszynami, lub podzielić z innymi)

aliasy których ja często używam używam:
```bash
alias open="explorer.exe ." # otwiera katalog w eksploratorze
# skróty do listowania katalogów:
alias ll="ls -la" 
alias la="ls -A"
alias wyjeb="rm -rf" # kasuje pliki z flagami -rf
alias mk-autoenv="touch .autoenv.zsh && touch .autoenv_leave.zsh" # tworzy pliki dla autoenva, zapobiega literówkom
# skróty dla gita:
alias gf="git fetch"
alias gp="git push"
alias pn="git push --no-verify"
alias pfn="git push --force --no-verify"
alias pf="git push --force"
alias rh="git reset --hard" # można wywołać samodzielnie, lub podać nazwę brancha/SHA commita
alias gs="git fetch && git pull" # fetch & pull
alias main-origin="git symbolic-ref --short refs/remotes/origin/HEAD" # pobiera nazwę domyślnego brancha dla repozytorium, jest to helper dla innych aliasów by developer nie musiał się zastanawiać nad nazwą domyślnego brancha (przydatne zwłaszcza jeśli są niespójne/nietypowe)
alias main="main-origin | sed 's/^origin\///'" # pobiera nazwę domyślnego brancha, bez origin/
alias st='git checkout $(main) && gs' # przechodzi na domyślny branch a następnie go synchronizuje
alias gcp="git cherry-pick" # robi cherry-pick, oczekuje SHA commita
alias wip="git add . && git commit -m 'wip' --no-verify" # zapisuje bieżące zmiany jako commit 'wip'
alias wipp="wip && git push --no-verify" # to co wip + wypycha zmiany na branch z pominięciem git hooków
# skróty dla narzędzi:
alias ide="code ."
alias poe="poetry run poe" 
alias tscwatch="npm run tscwatch"
# skróty per projekt (repo jako przykład):
alias repo-cd="cd ~/git/repo"
alias repo-start="repo-cd && npm run start"

alias zsh-reload="exec zsh" # restartuje powłokę, dzięki czemu zmiany w konfiguracji/aliasach wchodzą w życie
```

Jak widać wyżej, aliasy mogą się odwoływać do siebie nawzajem, więc jeśli między grupą aliasów są silne zależności, można zapewnić między nimi spójność.

### Globalny git ignore

Ponieważ autoenv tworzy pliki, będą one widoczne przez git. By temu zapobiec możemy stworzyć globalny `.gitignore`, który będzie respektowany we wszystkich repozytoriach co zapobiegnie przypadkowemu dodaniu tych plików do commitu. W tym celu:
- Stwórzmy sobie plik `~/.gitignore` gdzie będziemy listować wszystkie globalnie ignorowane pliki (składnia ta sama co w zwykłych `.gitignore`).
- W pliku `~/.gitconfig` w sekcji [core] dopiszmy `excludesfile = ~/.gitignore`.
Jeśli plik nie istnieje stwórzmy go, a wynik powinien wyglądać tak:
    ```
    [core]
            excludesfile = ~/.gitignore
    ```

> [!TIP]
> Ja w swoim globalnym `.gitignore` dodałem folder `.private`. Dzięki temu wiem, że jeśli potrzebuję napisać coś na brudno zawsze mogę skorzystać z tego folderu, bez obawy że takie śmieci trafią do gita.

> [!WARNING]
> Globalny `.gitignore` może ukryć potrzebę dopisania plików do `.gitignore` projektu. Np jeśli globalnie ignorujemy `node_modules`, ale nie będzie to zawarte w projekcie, to na naszej maszynie git nie będzie widział zmian, ale inny developer po `npm i` zobaczy ich wiele i może je wypchnąć do repo.

### autoenv - do czego użyć?

Wbrew nazwie `autoenv` może nam służyć do większej ilości rzeczy, niż tylko do zmiennych środowiskowych. Pozwala nam skonfigurować DOWOLNY skrypt który powinien się wykonać podczas wejścia lub opuszczania katalogu.

Przykłady użycia:
- odświeżenie credentiali do `az` lub innego narzędzia
- uruchamianie i zatrzymywanie `poetry shell` tak by był on aktywny tylko wewnątrz konkretnego katalogu
- ustawianie zmiennych systemowych (komenda `autostash` pozwala je łatwo nadpisać i odzyskać pierwotną wartość po opuszczeniu katalogu)
- standaryzacja za pomocą aliasów (np, alias `repo-start`, który będzie uruchamiał aplikację zgodnie ze specyfiką projektu)
- nadpisywanie generycznych aliasów na bardziej specyficzne (np, alias `ide` może uruchamiać inne IDE w zależności od repozytorium lub zamiast ścieżki do obecnego katalogu przekazać plik z workspace. Przy nadpisywaniu istniejących aliasów warto wykonać `exec zsh` albo `source "$ZSH_CUSTOM/aliases.zsh"` wychodząc z katalogu, by przywrócić aliasom ich pierwotne działanie)

### Przydatne wtyczki do VSCode

Oprócz wspomnianej [wtyczki WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) jest kilka innych przydatnych wtyczek, które warto zainstalować niezależnie od technologii w jakiej się pracuje np:

- [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) - prosta wtyczka podkreślająca słowa które wyglądają na literówki. Zawiera rozszerzenia z innymi językami (w tym polskim), a jeśli jakieś słowo niesłusznie jest podkreślane, możemy dodać je do słownika użytkownika/projektu (możemy to propagować na innych developerów przez `.vscode/settings.json` w repo)
- [Excalidraw](https://marketplace.visualstudio.com/items?itemName=pomdtr.excalidraw-editor) - Excalidraw to open-source wirtualna tablica. Można korzystać z niej w [przeglądarce](https://excalidraw.com/), jednak webowa wersja może być upierdliwa przy pracy z wieloma boardami. Wtyczka do VSCode pozwala trzymać pliki lokalnie/w repozytorium i łatwo się między nimi przełączać. Dodatkowo nie wymaga zmiany kontekstu z IDE do przeglądarki co może być rozpraszające ;) 

### Kolejne backupy

Środowisko w trakcie pracy będzie się zmieniać: będziesz mieć coraz więcej repozytoriów, więcej plików `autoenv` i więcej aliasów. Przed eksportem jednak warto pozbyć się wszystkiego co bez problemu możesz odzyskać. W swoim WSLu mam skrypt `exportCleanUp.sh` do którego dodaję komendy pomagające zaoszczędzić miejsce. Np:
```bash
# Czyszczenie pakietów
sudo apt-get autoremove
sudo apt-get clean

# skasowanie `node_modules` w katalogu `~/git` (środowisko NodeJS)
find ~/git -name "node_modules" -type d -print0 | xargs -0 rm -rf

# skasowanie `.venv` w katalogu `~/git` (środowisko Python)
find ~/git -name ".venv" -type d -print0 | xargs -0 rm -rf
```