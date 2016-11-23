# talkArm
A Handy Perl/Tk Talking Alarm

<img alt="talkArm Logo" src="http://ideaware.xyz/wp-content/uploads/2015/12/talkArm.png" width="48px" height="48px" />

## talkArm - { Talking Alarm }
An alarm that talks

### { Program Options }
in the user's **$HOME**, for storing program preferences and notes respectively.

The program will save options and data on exit and restore them when it loads.

Appending the **-m** option when running the program will start it minimized in the taskbar.

Right-clicking in the text area brings up a context menu for text manipulation.

### { Program Setup }
This program is going to be installed by default in your **$HOME/bin** directory. If you have not set your **$HOME/bin** in the **$PATH**, see [this](http://istos.xyz/linux/include-homebin-in-any-desktop-environment/ "Include $HOME/bin in any Desktop Environment") or [this snippet](http://istos.xyz/linux/include-homebin-in-the-path-for-bash-shell "Setup your $HOME/bin in the $PATH") for details.

To run this program, you need to have the following packages installed in your system (Check with your package manager):

- _**perl**_
- _**perl-tk**_
- _**libtk-gbarr-perl**_
- _**libtk-filedialog-perl**_
- _**libmath-round-perl**_
- _**libproc-processtable-perl**_
- _**speech-dispatcher**_

#### Once the above packages are installed
- Download the current version of **_talkArm__vX.Y.Z.tar_**
- Move the downloaded tarball into your **$HOME**, as all extracted files and directories will be relative to your **$HOME**
- Expand the tar file in a terminal by issuing:  
<code>**tar xf talkArm__vX.Y.Z.tar.tar**</code>
- Invoke the program from the terminal, running:  
<code>**talkArm &**</code>  
to ensure that it loads properly and no error messages are shown.

If everything has gone ok, you should be able to find the program in the _**Accessories**_ program group on your desktop manager.

### { File List }
The tarball contains these files (relative to the user's $HOME):
<pre>
bin/talkArm
.icons/talkArm.png
.local/share/applications/talkArm.desktop
</pre>
