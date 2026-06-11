sudo wget https://nonguix.org -O /etc/nonguix-signing-key.pub
echo 'export PATH="$HOME/.config/guix/current/bin:$PATH"' | sudo tee -a /root/.bashrc
echo 'alias gpull="rm -rf /tmp/guix-fast /root/.cache/guix && git clone --depth=1 https://codeberg.org /tmp/guix-fast && guix pull --allow-downgrades --disable-authentication"' | sudo tee -a /root/.bashrc
echo 'export PATH="$HOME/.config/guix/current/bin:$PATH"' | sudo tee -a /root/.bash_profile
echo 'alias gpull="rm -rf /tmp/guix-fast /root/.cache/guix && git clone --depth=1 https://codeberg.org /tmp/guix-fast && guix pull --allow-downgrades --disable-authentication"' | sudo tee -a /root/.bash_profile
sudo cp channels.scm /etc/guix/channels.scm

sudo awk '
{
    print $0
    if ($0 ~ /%desktop-services/ || $0 ~ /%base-services/) {
        print "     (guix-service-type config =>"
        print "                        (guix-configuration"
        print "                         (inherit config)"
        print "                         (substitute-urls"
        print "                          (append (list \"https://substitues.nonguix.org\")"
        print "                                  %default-substitute-urls))"
        print "                         (authorized-keys"
        print "                          (append (list (local-file \"/etc/nonguix-signing-key.pub\"))"
        print "                                  %default-authorized-guix-keys))))"
    }
}' /etc/config.scm > /tmp/config.tmp && sudo mv /tmp/config.tmp /etc/config.scm

echo "Pull by runnning 'gpull', 'hash guix' and then rebuild by running the 'firstreconfigure.sh' script"!
