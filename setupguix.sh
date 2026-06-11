sudo wget https://nonguix.org -O /etc/nonguix-signing-key.pub

echo 'export PATH="$HOME/.config/guix/current/bin:$PATH"' | sudo tee -a /root/.bashrc
echo 'alias gpull="rm -rf /tmp/guix-fast /root/.cache/guix && git clone --depth=1 https://codeberg.org /tmp/guix-fast && guix pull --allow-downgrades --disable-authentication"' | sudo tee -a /root/.bashrc
echo 'export PATH="$HOME/.config/guix/current/bin:$PATH"' | sudo tee -a /root/.bash_profile
echo 'alias gpull="rm -rf /tmp/guix-fast /root/.cache/guix && git clone --depth=1 https://codeberg.org /tmp/guix-fast && guix pull --allow-downgrades --disable-authentication"' | sudo tee -a /root/.bash_profile
sudo cp channels.scm /etc/guix/channels.scm

sudo tee -a /etc/config.scm << 'EOF'
(set! %operating-system-services
      (let ((old-services %operating-system-services))
        (lambda (os)
          (modify-services (old-services os)
            (guix-service-type config =>
                               (guix-configuration
                                (inherit config)
                                (substitute-urls
                                 (append (list "https://nonguix.org")
                                         %default-substitute-urls))
                                (authorized-keys
                                 (append (list (local-file "/etc/nonguix-signing-key.pub"))
                                         %default-authorized-guix-keys))))))))
EOF

echo "Pull by running 'gpull', 'hash guix' and then rebuild by running the 'firstreconfigure.sh' script!"
