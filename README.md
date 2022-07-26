# dotfiles
Lucas Mello's dotfiles

# Almost ready
These files are part of a full os bootstrap. The instructions to use them are not yet available, but soon they will be.
The main option is to implement this setup from scratch (really) using a kickstarter script along with the os bootable drive ISO.
This kickstarter file is being stress tested and will probably be the last feature I'll make available. 
The second option is to implement this right after the os is installed. This is done with a single-line command that pulls an Ansible playbook. This playbook is not available yet. I am stress testing it and soon it will be included as a submodule, along with the instructions to use it.
Finally, a lot of the config files (dotfiles) are still being sanitized, hence they are still missing. However, if you notice them, you will probably already have your own.

# Feel free to try it out as is
The kickstart script is yet to come and full instructions are on the way.
Until then, fell free to play it out: after installing fedora, run:
`source <(wget -qO- https://raw.github.com/mellolucas/bootstrap-fedora/main/bootstrap.sh)`
and follow the instructions you'll be presented with.

# LICENSE
<p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><a property="dct:title" rel="cc:attributionURL" href="https://github.com/mellolucas/dotfiles">Lucas Mello's dotfiles</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://github.com/mellolucas">Lucas F O Mello</a> is licensed under <a href="http://creativecommons.org/licenses/by-sa/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY-SA 4.0<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1"></a></p>

