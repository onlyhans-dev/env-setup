# Prosty CLI tool do korzystania z loklanych plików .excalidraw wraz z wtyczką do VSCode
# Potrzebna wtyczka: https://marketplace.visualstudio.com/items?itemName=pomdtr.excalidraw-editor
#
# Prompty z tłumaczeniem:
# https://www.perplexity.ai/search/napisz-mi-prosty-alias-funkcje-FD0h8uIKS1ed_u.61QQQLg
# https://www.perplexity.ai/search/czy-mozesz-przepisac-ten-kod-b-zL1JADFlTGe5CkWGrzqkIw
#
# Aby funkcja była dostępna w terminalu poniższy kod należy dodać do pliku `~/.bashrc`/`~/.zshrc` lub innego wykonywanego przy starcie powłoki
#
# Przykład użycia z zapisem do katalogu `~/excalidraw`: exdraw test
# Przykład użycia z zapisem do bieżącego katalogu `~/excalidraw`: exdraw ./test

_exdraw_complete() {
  # CLI na tabie podpowiada nazwy plików przechowywanych w `~/excalidraw`
  local -a files
  files=(${(f)"$(ls ~/excalidraw/*.excalidraw 2>/dev/null)"})
  files=(${files:#*~})   # pomiń pliki backupowe
  files=("${files[@]##*/}")   # usuń ścieżki
  files=("${files[@]%.excalidraw}") # usuń rozszerzenie
  compadd -- ${files[@]}
}

exdraw() {
  local file_path
  if [[ "$1" == ./* ]]; then
    file_path="$1.excalidraw"
  else
    mkdir -p "$HOME/excalidraw"
    file_path="$HOME/excalidraw/$1.excalidraw"
  fi
  touch $file_path
  code $file_path
}
compdef _exdraw_complete exdraw