# Ansible playbook to upgrade packages

Modify `hosts` and run `ansible-playbook -i hosts upgrade.yaml`.

Note: On debain to make reboot detect work, you may install `unattended-upgrades`.