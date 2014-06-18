# -*- mode: ruby -*-
# vi: set ft=ruby :

sensors = {
  manresa: {
    mac: '1665e9faf6dd',
    coords: '41.7292826,1.8225154'
  },
  tortosa: {
    mac: '66bb131c9662',
    coords: '40.8125777, 0.5214423'
  },
  palafrugell: {
    mac: '1add3146a2ab',
    coords: '41.9179112, 3.1629611'
  },
  lleida: {
    mac: '523095eaf9a4',
    coords: '41.6175899, 0.62001459'
  }
}

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # prevent 'stdin: is not a tty' error
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  sensors.keys.each do |name|
    config.vm.define name do |sensor|
      sensor.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--name", name.to_s, "--memory", "128", "--macaddress1", sensors[name][:mac]]
      end
      sensor.vm.box = "precise32_ruby200"
      sensor.vm.host_name = name.to_s
      sensor.vm.network :private_network, type: :dhcp
    end

    config.vm.provision "shell", path: "provisioning.sh", args: sensors[name][:coords]
  end

end
