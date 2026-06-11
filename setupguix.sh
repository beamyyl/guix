sudo wget https://substitutes.nonguix.org/signing-key.pub -O /etc/nonguix-signing-key.pub
echo 'export PATH="$HOME/.config/guix/current/bin:$PATH"' | sudo tee -a /root/.bashrc
echo 'alias gpull="rm -rf /tmp/guix-fast /root/.cache/guix && git clone --depth=1 https://codeberg.org/guix/guix.git /tmp/guix-fast && guix pull --allow-downgrades --disable-authentication"' | sudo tee -a /root/.bashrc
echo 'export PATH="$HOME/.config/guix/current/bin:$PATH"' | sudo tee -a /root/.bash_profile
echo 'alias gpull="rm -rf /tmp/guix-fast /root/.cache/guix && git clone --depth=1 https://codeberg.org/guix/guix.git /tmp/guix-fast && guix pull --allow-downgrades --disable-authentication"' | sudo tee -a /root/.bash_profile
sudo cp channels.scm /etc/guix/channels.scm
echo "Pull by runnning 'gpull', 'hash guix' and then rebuild by running the 'firstreconfigure.sh' script"!
