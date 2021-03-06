#! /usr/bin/fish

# Autobackup script for dotfiles, fish function, fish abbeviations and other config files.
#
# Runs every 5 minutes via crontab.
# 
# Needs patched NotifyOSD for notify-send --expire-time to work.
# @see http://www.webupd8.org/2014/04/configurable-notification-bubbles-for.html
# 
# @todo Make commit messages a bit more detailed about what files changed.

# Crontab setup needed to use notify-send, add below to crontab.
# @see http://unix.stackexchange.com/a/111189/27902                                 
# 
# DISPLAY=:0.0                                                                        
# * * * * * /home/elijah/.oh-my-fish/custom/homeshick_backup.fish > /dev/null 2>&1    

set --global push_needed no 
# @todo Use these as a --quiet flag in git.
set --global debug_mode false
cd $HOME/.homesick/repos/dotfiles

# keychain support, so crontab doesn't ask for a key passphrase every git push.
# @see http://superuser.com/a/933903/30982
source $HOME/.keychain/(hostname)-fish

# Export Fish abbreviations and commit them.
abbr --show | sort > fish_abbreviation_backup;
if not git diff --quiet fish_abbreviation_backup
    # fish doesn't sort abbr --show yet so lets source it in as such.
    # @see https://github.com/fish-shell/fish-shell/issues/2156
    source fish_abbreviation_backup

    git add fish_abbreviation_backup
    git commit --message "Update Fish abbreviations"
    set push_needed yes
end

# Homeshick track any new functions
if not diff --recursive $HOME/.config/fish/functions $HOME/.homesick/repos/dotfiles/home/.config/fish/functions
    cd $HOME/.config/fish/functions
    homeshick track dotfiles *
    cd -
    git add --all
    git commit --message "Update functions"
    set push_needed yes 
end

# Commit any dotfiles changes.
if not git diff --quiet; or not git diff --cached --quiet

       # Update dotfiles.
       git add --all
       git commit --message "Update dotfiles"
       set push_needed yes 
end

# Push & Notify.
if test $push_needed = yes
    git push
    if test (git rev-parse --verify master) = (git rev-parse --verify origin/master)
        notify-send --expire-time=3000 "Dotfiles updated and pushed to Github"
    else
        notify-send --expire-time=3000 "There was a problem pushing your dotfiles to Github"
    end
else
    notify-send --expire-time=3000 'Nothing changed'
end
