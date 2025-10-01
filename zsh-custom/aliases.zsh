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