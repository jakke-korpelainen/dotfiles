# aliases
alias docker='echo "# re-routing to podman " && podman'
alias explorer='yazi'
alias files='yazi'
alias calc='kalker'
alias dev='cd ~/Development'
alias zed='zeditor'
alias gs='git status'
alias add='git add .'
alias gp='git pull'

alias latest='git tag --sort=-v:refname | head -n 1 | sed 's/^v//''
alias git-branches='git branch --sort=-committerdate'
alias main='git checkout main'

function gnb --argument-names branch
    git checkout -b $branch
end

function gb --argument-names branch
    git checkout $branch
end

function commit --argument-names arg1
    git commit -m"$arg1"
end

function chore --argument-names msg
    commit "chore: $msg"
end

function feat --argument-names msg
    commit "feat: $msg"
end

function fix --argument-names msg
    commit "fix: $msg"
end

function refactor --argument-names msg
    commit "refactor: $msg"
end
