# edid file
edid_dest := "/lib/firmware/edid/70hz.bin"
# dracut conf file to write into
dracut_conf := "/etc/dracut.conf.d/70hz.conf" 

# make dracut conf and enable initramfs (handled if already enabled)
configure-initramfs:
  #!/bin/bash
  # Ensure the dracut conf dir exists
  sudo mkdir -p /etc/dracut.conf.d
  # Check if the EDID file is already included in the initramfs conf
  if grep -q "{{edid_dest}}" {{dracut_conf}}; then
    echo "EDID file is already included in the dracut configuration."
  # if not, include it  
  else
    echo "install_items+=\" {{edid_dest }} \"" | sudo tee {{dracut_conf}}
    sudo rpm-ostree initramfs --enable
  fi

# Main 
# type "just <name_of_this_function>" to run the process
overclock-display: configure-initramfs 
  #!/bin/bash
  sudo rpm-ostree kargs --append-if-missing=drm.edid_firmware=eDP-1:edid/70hz.bin # add edid file as kernel arg
  sudo rpm-ostree kargs --append-if-missing=firmware_class.path=/lib/firmware # add path as kernel arg
  echo "All done. Please reboot your system."
