cp /ctx/libvirt-workaround.service /usr/lib/systemd/system/
mkdir /var/log/libvirt
chmod /var/log/libvirt 0750
systemctl enable libvirt-workaround.service
