# ------------------------------
# set PATH
# ------------------------------

# dreambredge facebook ids
export DB_FACEBOOK_APP_ID=1706329032949387
export DB_FACEBOOK_SECRET=dcbdf4dad7b09408716fac39bfc0914c

# direnv
eval "$(direnv hook zsh)"

# go
export GOPATH=~/Documents/go

#tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

#pyenv
export PATH="$HOME/.pyenv/shims:$PATH"

#python
export PATH=/usr/local/bin:/usr/local/share/python:$PATH
export SLACK_API_TOKEN=xoxp-4436077663-4414064360-11880894870-721aa12163
#latex
export PATH=/usr/texbin:$PATH

export PATH=/usr/bin/gawk:$PATH

# php
export PATH=/usr/local/php5/bin:$PATH

# scala
export PATH="$HOME/Documents/PL/scala/bin:$PATH"

# PATH for $HOME/bin
export PATH="$HOME/bin:$PATH"

# cabal
export PATH="$HOME/.cabal/bin:$PATH" 

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

# java
export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8

# brew
export PATH=/usr/local/bin:$PATH

# nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

# nginx
export PATH=$PATH:/usr/local/sbin

# ------------------------------
# General Settings
# ------------------------------
export EDITOR=vim        # エディタをvimに設定
export LANG=ja_JP.UTF-8  # 文字コードをUTF-8に設定
export KCODE=u           # KCODEにUTF-8を設定
export AUTOFEATURE=true  # autotestでfeatureを動かす

bindkey -e               # キーバインドをemacsモードに設定
#bindkey -v              # キーバインドをviモードに設定

setopt no_beep           # ビープ音を鳴らさないようにする
setopt auto_cd           # ディレクトリ名の入力のみで移動する 
setopt auto_pushd        # cd時にディレクトリスタックにpushdする
setopt correct           # コマンドのスペルを訂正する
setopt magic_equal_subst # =以降も補完する(--prefix=/usrなど)
setopt prompt_subst      # プロンプト定義内で変数置換やコマンド置換を扱う
setopt notify            # バックグラウンドジョブの状態変化を即時報告する
setopt equals            # =commandを`which command`と同じ処理にする

### Complement ###
autoload -U compinit; compinit # 補完機能を有効にする
setopt auto_list               # 補完候補を一覧で表示する(d)
setopt auto_menu               # 補完キー連打で補完候補を順に表示する(d)
setopt list_packed             # 補完候補をできるだけ詰めて表示する
setopt list_types              # 補完候補にファイルの種類も表示する
bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完時に大文字小文字を区別しない

### Glob ###
setopt extended_glob # グロブ機能を拡張する
unsetopt caseglob    # ファイルグロブで大文字小文字を区別しない

### History ###
HISTFILE=~/.zsh_history   # ヒストリを保存するファイル
HISTSIZE=10000            # メモリに保存されるヒストリの件数
SAVEHIST=10000            # 保存されるヒストリの件数
setopt bang_hist          # !を使ったヒストリ展開を行う(d)
setopt extended_history   # ヒストリに実行時間も保存する
setopt hist_ignore_dups   # 直前と同じコマンドはヒストリに追加しない
setopt share_history      # 他のシェルのヒストリをリアルタイムで共有する
setopt hist_reduce_blanks # 余分なスペースを削除してヒストリに保存する

# マッチしたコマンドのヒストリを表示できるようにする
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# すべてのヒストリを表示する
function history-all { history -E 1 }


# ------------------------------
# Look And Feel Settings
# ------------------------------
### PRONPT ###
PROMPT='%n%# '
OK="^_^ "
NG="*_* "

PROMPT=""
PROMPT+="%(?.%F{green}$OK%f.%F{red}$NG%f) "

RPROMPT=""

setopt prompt_subst

### Ls Color ###
# 色の設定
export LSCOLORS=Exfxcxdxbxegedabagacad
# 補完時の色の設定
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# ZLS_COLORSとは？
export ZLS_COLORS=$LS_COLORS
# lsコマンド時、自動で色がつく(ls -Gのようなもの？)
export CLICOLOR=true
# 補完候補に色を付ける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# ------------------------------
# Other Settings
# ------------------------------
### Aliases ###
alias v=vim
alias be='bundle exec'
alias r=rails
alias n=node
alias cw='compass watch'
alias mystart='mysql.server start'
alias mystop='mysql.server stop'
alias egrep='egrep -r'
alias la="ls -a"
alias ll="ls -l"
alias du="du -h"
alias df="df -h"


# cdコマンド実行後、lsを実行する
function cd() {
  builtin cd $@ && ls;
}

# mkdir後、そのディレクトリに移動する
function mkcd {
  dir="$*";
  mkdir -p "$dir" && cd "$dir";
}

# sudo vim
sudo() {
  local args
  case $1 in
    vi|vim)
      args=()
      for arg in $@[2,-1]
      do
        if [ $arg[1] = '-' ]; then
          args[$(( 1+$#args ))]=$arg
        else
          args[$(( 1+$#args ))]="sudo:$arg"
        fi
      done
      command vim $args
      ;;
    *)
      command sudo $@
      ;;
  esac
}

#########################
#    gitのbranch表示    #
#########################

function prompt-git-current-branch {
        local name st color

        if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
                return
        fi
        name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
        if [[ -z $name ]]; then
                return
        fi
        st=`git status 2> /dev/null`
        if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
                color=cyan
        elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
                color=yellow
        elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
                color=red
        else
                color=red
        fi

        echo "%F{$color}$name%f"
}

PROMPT+='%F{green}[%~ `prompt-git-current-branch`%F{green}]%f'
PROMPT+="
"
PROMPT+="%% "
 
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
