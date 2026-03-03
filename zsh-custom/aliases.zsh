main() {
    # 1. Wykryj, który remote jest priorytetem (upstream dla forków, origin dla reszty)
    local remote
    if git remote | grep -qW "upstream"; then
        remote="upstream"
    else
        remote="origin"
    fi

    local ref
    # 2. Szybki odczyt lokalny (offline)
    ref=$(git symbolic-ref --short "refs/remotes/$remote/HEAD" 2>/dev/null)

    # 3. Jeśli brak wskaźnika, spróbuj go zainicjalizować (wymaga sieci)
    if [ -z "$ref" ]; then
        git remote set-head "$remote" -a >/dev/null 2>&1
        ref=$(git symbolic-ref --short "refs/remotes/$remote/HEAD" 2>/dev/null)
    fi

    # 4. Ostateczny fallback (Twoja oryginalna metoda)
    if [ -z "$ref" ]; then
        ref=$(git remote show "$remote" 2>/dev/null | grep 'HEAD branch' | cut -d' ' -f5)
    fi

    # Wyświetl czystą nazwę gałęzi (usuwa prefix remote'a)
    if [ -n "$ref" ]; then
        echo "${ref#$remote/}"
    else
        # Jeśli wszystko zawiedzie, najprawdopodobniej jest to 'main' lub 'master'
        git branch -r | grep -q "origin/main" && echo "main" || echo "master"
    fi
}

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
alias st='git checkout $(main) && gs' # przechodzi na domyślny branch a następnie go synchronizuje
alias gcp="git cherry-pick" # robi cherry-pick, oczekuje SHA commita
alias rb='git fetch && git rebase $(main-origin)' # rebase do domyślnego brancha
alias rbc="git rebase --continue" # kontynuuje rebase w przypadku konfliktów
alias gs="git fetch && git pull" # synchronizuje branch
alias wip="git add . && git commit -m 'wip' --no-verify" # zapisuje bieżące zmiany jako commit 'wip'
alias wipp="wip && git push --no-verify" # to co wip + wypycha zmiany na branch z pominięciem git hooków
# skróty dla narzędzi:
alias ide="code ."
alias poe="poetry run poe" 
alias tscwatch="npm run tscwatch"
# skróty per projekt (repo jako przykład):
alias repo-cd="cd ~/git/repo"
alias repo-start="repo-cd && npm run start"

alias zsh-custom="code ${ZSH_CUSTOM}" # szybki dostęp do folderu z customizacją zsh
alias zsh-aliases-reload="source ${ZSH_CUSTOM}/aliases.zsh" # odświeżenie definicji aliasów (przydatne jeśli nadpisuje się jakieś aliasy w autoenv)
alias zsh-config="code ~/.zshrc" # szybki dostęp do pliku .zshrc
alias zsh-reload="exec zsh" # restartuje powłokę, dzięki czemu zmiany w konfiguracji/aliasach wchodzą w życie