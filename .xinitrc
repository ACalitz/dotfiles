[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

hsetroot -full /home/rez/Pictures/bwDeer.jpg &

sxhkd &
panel &

compton --config ~/.compton.conf -b &

exec bspwm
