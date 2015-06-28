#! /usr/bin/fish
# Runs every 5 minutes via crontab.

source $HOME/.keychain/(hostname)-fish
set -x -U SSH_AGENT_PID 1431
notify-send -t 1000 $SSH_AGENT_PID

cd $HOME/.homesick/repos/dotfiles

# Commit any dotfiles changes.
if not git diff --exit-code;
   not git diff --cached --exit-code;
   git ls-files --other --exclude-standard --directory;
   abbr --show | sort > fish_abbreviation_backup;
        # Export Fish abbreviations and commit them.
        if not git diff --exit-code fish_abbreviation_backup
            git add fish_abbreviation_backup
            git commit --message "Update Fish abbreviations"
        end

        # Update dotfiles.
        git add --all
        git commit --message "Update dotfiles"

        # Push & Notify.
        git push
        if test (git rev-parse --verify master) = (git rev-parse --verify origin/master)
            notify-send --expire-time=1000 "Dotfiles updated and pushed to Github"
        else
            notify-send --expire-time=1000 "There was a problem pushing your dotfiles to Github"
        end
end
