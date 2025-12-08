# aliases
alias docker='echo "# re-routing to podman " && podman'
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

function mistral_chat --argument-names message
    set -l json_data (jq -n --arg message "$message" '{
        model: "mistral-large-latest",
        messages: [
            {
                role: "user",
                content: $message
            }
        ],
        stream: true
    }')

    set -l full_stream ""

    curl \
        --location "https://api.mistral.ai/v1/chat/completions" \
        --header 'Content-Type: application/json' \
        --header 'Accept: application/json' \
        --header "Authorization: Bearer $MISTRAL_API_KEY" \
        --data "$json_data" \
        --silent \
        --no-buffer \
            | while read -l line
                if string match -q -- "data: [DONE]" $line
                    break
                end
                set -l json_line (echo $line | sed 's/^data: //')
                set -l content (echo $json_line | jq -r '.choices[0].delta.content // empty' | sed 's/\r/\n/g')
                set full_stream "$full_stream$content"
                echo -n $content
            end
    echo -n "$full_stream" | glow -
end

alias ai='mistral_chat'
