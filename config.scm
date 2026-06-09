(use-modules (gnu)
	     (gnu services)
	     (gnu services base)
	     (gnu services desktop)
	     (guix packages)
	     (nongnu packages linux)
	     (nongnu system linux-initrd)
	     (gnu packages admin)
	     (gnu packages terminals)
	     (gnu packages wm)
	     (gnu packages lxde)
	     (gnu packages version-control)
	     (gnu packages librewolf)
	     (gnu packages ncurses)
	     (gnu packages glib)
	     (gnu packages vim))

(use-service-modules cups desktop dbus networking ssh xorg)

(operating-system
  (kernel linux-lts)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (locale "en_US.utf8")
  (timezone "Europe/Bucharest")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "guix")

  (users (cons* (user-account
		  (name "beamy")
		  (comment "Beamy")
		  (group "users")
		  (home-directory "/home/beamy")
		  (supplementary-groups '("wheel" "netdev" "audio" "video")))
		%base-user-accounts))

  (packages (append (list
		      fastfetch
		      alacritty
		      pcmanfm
		      git
		      sway
		      ncurses
		      dbus
		      librewolf
		      waybar
		      vim)
		    %base-packages))
  ;; apps
  (services 
      (append (list (service network-manager-service-type)
		    (service wpa-supplicant-service-type)
		    (service elogind-service-type)
		    (service ntp-service-type)
		    (service gpm-service-type))
	      	(modify-services %base-services
      (guix-service-type config =>
			 (guix-configuration
			   (inherit config)
			   (substitute-urls
			     (append (list "https://substitutes.nonguix.org")
				     %default-substitute-urls))
			   (authorized-keys
			     (append (list (local-file "/etc/nonguix-signing-key.pub"))
				     %default-authorized-guix-keys)))))))

  (bootloader (bootloader-configuration
		(bootloader grub-bootloader)
		(targets (list "/dev/sda"))
		(keyboard-layout keyboard-layout)))

  (file-systems (cons* (file-system
			 (mount-point "/")
			 (device (uuid "1894ede5-64cf-410d-a414-48b9318c41ea"))
			 (type "ext4"))
		       %base-file-systems)))
