use 5.36.0;
use Rex -feature => ['1.4'];


# No Magic
my $USERHOME = "$ENV{HOME}";
my $GITHUB   = "https://github.com";

# Set PATH explicitly
$ENV{'PATH'} =
    '/bin:/usr/bin:/sbin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:$HOME/bin';

# task to clean home dir
task 'remove_default_cruft', sub {
    unlink(
        "$USERHOME/.cshrc",   "$USERHOME/.login",     "$USERHOME/.mailrc",
        "$USERHOME/.profile", "$USERHOME/.Xdefaults", "$USERHOME/.cvsrc"
        );
    system( 'doas', 'chmod', '0700', "$USERHOME" );
};

# Configures and installs urxvt perls
task 'configure_urxvt', sub {
    my %perls = (
        "resize-font" => "$GITHUB/simmel/urxvt-resize-font/raw/master/resize-font",
        "clipboard"   => "$GITHUB/xyb3rt/urxvt-perls/raw/master/deprecated/clipboard"
        );
    keys %perls;
    my $urxvtdir = "$USERHOME/.urxvt/ext";
    mkdir ($urxvtdir)
        or $!{EEXIST}
        or die ("Cant create $urxvtdir! \n");
    while (my($k, $v) = each %perls) {
        my $dest = "$urxvtdir/$k";
        my $source  = "$v";
        system( 'ftp', '-o', "$dest", "$source" );
    }
};

# Configures and sets up the default shell
task 'configure_default_shell', sub {
    my %plugins = (
        "openbsd"     => "$GITHUB/sizeofvoid/openbsd-zsh-completions.git",
        "completions" => "$GITHUB/zsh-users/zsh-completions.git",
        "fzf-comp"    => "$GITHUB/lincheney/fzf-tab-completion.git",
        "suggest"     => "$GITHUB/zsh-users/zsh-autosuggestions.git",
        "substring"   => "$GITHUB/zsh-users/zsh-history-substring-search.git",
        "fzf"         => "$GITHUB/Aloxaf/fzf-tab.git",
        "256"         => "$GITHUB/chrissicool/zsh-256color.git",
        "fsh"         => "$GITHUB/zdharma-continuum/fast-syntax-highlighting.git",
        "autopair"    => "$GITHUB/hlissner/zsh-autopair",
        "defer"       => "$GITHUB/romkatv/zsh-defer",
        "vim-mode"    => "$GITHUB/softmoth/zsh-vim-mode"
        );
    keys %plugins;
    my $zshdir = "$USERHOME/.zshrc.d";
    mkdir ($zshdir)
        or $!{EEXIST} # Don't die if $zshdir exists
        or die ("Cant create $zshdir! \n");
    while (my($k, $v) = each %plugins) {
        my $clonedir = "$zshdir/$k";
        my $cloneuri = "$v";
        if ( -d $clonedir ) {
            chdir "$clonedir";
            system( 'git', 'pull' );
        } else {
            system( 'git', 'clone', "$cloneuri", "$clonedir" );
        }
    }
    system( 'chsh', '-s', '/usr/local/bin/zsh' );
};

task 'configure_gtk', sub {
    my %gtk = (
        "gruvbox-plus-gtk" => "$GITHUB/SylEleuth/gruvbox-plus-gtk.git",
        );
    keys %gtk;
    while (my($k, $v) = each %gtk) {
        my $clonedir = "/tmp/$k";
        my $cloneuri = "$v";
        if ( -d "$clonedir" ) {
            chdir "$clonedir";
            system( 'git', 'pull', '--depth', '1' );
        } else {
            system( 'git', 'clone', '--depth', '1', "$cloneuri", "$clonedir" );
        }
        system( 'cp', '-R', glob("$clonedir/*"), "$USERHOME/.dotfiles/.themes/" );
        unlink("$clonedir");
    }
};

task 'configure_icons', sub {
    my %icons = (
        "gruvbox-round-icons" => "$GITHUB/Fausto-Korpsvart/Gruvbox-GTK-Theme.git",
        );
    keys %icons;
    while (my($k, $v) = each %icons) {
        my $clonedir = "/tmp/$k";
        my $cloneuri = "$v";
        if ( -d "$clonedir" ) {
            chdir "$clonedir";
            system( 'git', 'pull', '--depth', '1' );
        } else {
            system( 'git', 'clone', '--depth', '1', "$cloneuri", "$clonedir" );
        }
        system( 'cp', '-R', glob("$clonedir/icons/*"), "$USERHOME/.dotfiles/.icons/" );
        unlink("$clonedir");
    }
};

# Configures and installs emacs
task 'configure_emacs', sub {
    if ( -d "$USERHOME/.emacs.d" ) {
        chdir "$USERHOME/.emacs.d";
    } else {
        system( 'ln', '-sf', "$USERHOME/.dotfiles/Emacs-Config", "$USERHOME/.emacs.d" );
    }
};

task 'configure_stumpwm', sub {
    if ( -d "$USERHOME/.stumpwm.d" ) {
        chdir "$USERHOME/.stumpwm.d";
    } else {
        system( 'ln', '-sf', "$USERHOME/.dotfiles/StumpWM-Config", "$USERHOME/.stumpwm.d" );
    }
};

task 'configure_emwm', sub {
    system( 'ln', '-sf', "$USERHOME/.dotfiles/Emwm-Config/.emwmrc", "$USERHOME/.emwmrc" );
    system( 'ln', '-sf', "$USERHOME/.dotfiles/Emwm-Config/.toolboxrc", "$USERHOME/.toolboxrc" );
    system( 'mkdir', '-p', "$USERHOME/.xresources.d" );
    system( 'ln', '-sf', "$USERHOME/.dotfiles/Emwm-Config/.xresources", "$USERHOME/.xresources.d/emwm" );
};

# Installs backgrounds to /usr/local/share/backgrounds
task 'install_backgrounds', sub {
    system( 'doas', 'mkdir', '-p', '/usr/local/share/backgrounds' );
    system( 'doas',  'cp', '-R', glob("$USERHOME/.dotfiles/backgrounds/*"), '/usr/local/share/backgrounds' );
};

# Sets up Xenodm configuration
task 'configure_xenodm', sub {
    system( 'chmod', '+x', glob("$USERHOME/.dotfiles/XenoDM-Config/Xsetup_*"), glob("$USERHOME/.dotfiles/XenoDM-Config/GiveConsole"));
    system( 'doas', 'cp', '-R', glob("$USERHOME/.dotfiles/XenoDM-Config/*"), '/etc/X11/xenodm/' );
};

task 'configure_apmd', sub {
    system( 'doas', 'mkdir', '/etc/apm' );
    system( 'doas', 'cp', '-R', glob("$USERHOME/.dotfiles/APM-Config/*"), '/etc/apm/' );
};

# Compiles shuf re-implementation
task 'compile_shuf', sub {
    system( 'git', 'clone', "$GITHUB/ibara/shuf.git", "$USERHOME/.shuf" );
    chdir "$USERHOME/.shuf";
    system( './configure' );
    system( 'make' );
    system( 'doas', 'make', 'install' );
};

# Compiles in my Slock Setup
task 'compile_slock', sub {
    system( 'git', 'clone', "$GITHUB/Izder456/slock.git", "$USERHOME/.slock" );
    chdir "$USERHOME/.slock";
    system( 'make' );
    system( 'doas', 'make', 'install' );
};

# Compiles in my SURF Setup
task 'compile_surf', sub {
    system( 'git', 'clone', "$GITHUB/Izder456/surf.git", "$USERHOME/.surf-src" );
    chdir "$USERHOME/.surf-src";
    system( 'make' );
    system( 'doas', 'make', 'install' );
};

# Compiles in my ST Setup
task 'compile_st', sub {
    system( 'git', 'clone', "$GITHUB/Izder456/st.git", "$USERHOME/.st" );
    chdir "$USERHOME/.st";
    system( 'make' );
    system( 'doas', 'make', 'install' );
};

# Compiles afetch
task 'compile_afetch', sub {
    system( 'git', 'clone', "$GITHUB/13-CF/afetch.git", "$USERHOME/.afetch" );
    chdir "$USERHOME/.afetch";
    system( 'make' );
    system( 'doas', 'make', 'install' );
};

task 'compile_nxbelld', sub {
    $ENV{'AUTOCONF_VERSION'} = "2.69";
    $ENV{'AUTOMAKE_VERSION'} = "1.16";
    system( 'git', 'clone', "$GITHUB/dusxmt/nxbelld.git", "$USERHOME/.nxbelld" );
    chdir "$USERHOME/.nxbelld";
    system('autoreconf -i');
    system( './configure', '--prefix', "$USERHOME/.local");
    system( 'gmake' );
    system( 'gmake', 'install' );
};

# Updates XDG user directories
task 'update_xdg_user_dirs', sub {
    system( 'xdg-user-dirs-update' );
    system( 'mkdir', "$USERHOME/Projects" );
    system( 'doas', 'gdk-pixbuf-query-loaders', '--update-cache' );
};
