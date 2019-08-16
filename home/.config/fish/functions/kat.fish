function kat
    pygmentize -g $argv | awk '{print i++ + 1 "   " $0}'
end
