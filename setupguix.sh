sudo wget https://nonguix.org -O /etc/nonguix-signing-key.pub
echo 'export PATH="$HOME/.config/guix/current/bin:$PATH"' | sudo tee -a /root/.bashrc
echo 'alias gpull="rm -rf /tmp/guix-fast /root/.cache/guix && git clone --depth=1 https://codeberg.org /tmp/guix-fast && guix pull --allow-downgrades --disable-authentication"' | sudo tee -a /root/.bashrc
echo 'export PATH="$HOME/.config/guix/current/bin:$PATH"' | sudo tee -a /root/.bash_profile
echo 'alias gpull="rm -rf /tmp/guix-fast /root/.cache/guix && git clone --depth=1 https://codeberg.org /tmp/guix-fast && guix pull --allow-downgrades --disable-authentication"' | sudo tee -a /root/.bash_profile
sudo cp channels.scm /etc/guix/channels.scm

if grep -q "%desktop-services" /etc/config.scm; then
    guix shell sd -- sd '\(%desktop-services\)\)' '(%desktop-services)
     (guix-service-type config =>
                        (guix-configuration
                         (inherit config)
                         (substitute-urls
                          (append (list "https://nonguix.org")
                                  %default-substitute-urls))
                         (authorized-keys
                          (append (list (local-file "/etc/nonguix-signing-key.pub"))
                                  %default-authorized-guix-keys))))' /etc/config.scm
else
    guix shell sd -- sd '\(%base-services\)\)' '(%base-services)
     (guix-service-type config =>
                        (guix-configuration
                         (inherit config)
                         (substitute-urls
                          (append (list "https://nonguix.org")
                                  %default-substitute-urls))
                         (authorized-keys
                          (append (list (local-file "/etc/nonguix-signing-key.pub"))
                                  %default-authorized-guix-keys))))' /etc/config.scm
fi

echo "Pull by runnning 'gpull', 'hash guix' and then rebuild by running the 'firstreconfigure.sh' script"!
