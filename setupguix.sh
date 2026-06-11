sudo wget https://substitutes.nonguix.org/signing-key.pub -O /etc/nonguix-signing-key.pub
echo 'export PATH="$HOME/.config/guix/current/bin:$PATH"' | sudo tee -a /root/.bashrc
echo 'alias gpull="rm -rf /tmp/guix-fast /root/.cache/guix && git clone --depth=1 https://codeberg.org /tmp/guix-fast && guix pull --allow-downgrades --disable-authentication"' | sudo tee -a /root/.bashrc
echo 'export PATH="$HOME/.config/guix/current/bin:$PATH"' | sudo tee -a /root/.bash_profile
echo 'alias gpull="rm -rf /tmp/guix-fast /root/.cache/guix && git clone --depth=1 https://codeberg.org /tmp/guix-fast && guix pull --allow-downgrades --disable-authentication"' | sudo tee -a /root/.bash_profile
sudo cp channels.scm /etc/guix/channels.scm

sudo awk '
{
    if ($0 ~ /%desktop-services/ || $0 ~ /%base-services/) {
        match($0, /%[a-z\-]+services/)
        service_name = substr($0, RSTART, RLENGTH)

        gsub(/%[a-z\-]+services/, "(modify-services " service_name "\n     (guix-service-type config =>\n                        (guix-configuration\n                         (inherit config)\n                         (substitute-urls\n                          (append (list \"https://substitutes.nonguix.org\")\n                                  %default-substitute-urls))\n                         (authorized-keys\n                          (append (list (local-file \"/etc/nonguix-signing-key.pub\"))\n                                  %default-authorized-guix-keys)))))", $0)
    }
    print $0
}' /etc/config.scm > /tmp/config.tmp && sudo mv /tmp/config.tmp /etc/config.scm

echo "Pull by runnning 'gpull', 'hash guix' and then rebuild by running the 'firstreconfigure.sh' script"!
