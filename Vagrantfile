# -*- mode: ruby -*-
# vi: set ft=ruby :

# Generates IEEE locally-assigned MAC addresses
#
# @return [String] following the pattern [0-9A-Fa-f][26AEae][0-9A-Fa-f]{10}
def mac
  mac = ('%0.2X' % rand(256))[0, 1] + %w(2 6 A E).sample
  mac << (1..5).map { "%0.2X" % rand(256) }.join
end

sensors = {
 # barcelona: '41.3850639,2.1734035',
  manresa: '41.7292826,1.8225154',
  tortosa: '40.8125777, 0.5214423',
  palafrugell: '41.9179112, 3.1629611',
 # solsona: '41.995121, 1.517781',
  lleida: '41.6175899, 0.62001459',
 # sort: '42.4110889, 1.13014169'
}

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # prevent 'stdin: is not a tty' error
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  sensors.keys.each do |name|
    config.vm.define name do |sensor|
      sensor.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--name", name.to_s, "--memory", "128", "--macaddress1", mac]
      end
      sensor.vm.box = "precise32_ruby200"
      sensor.vm.host_name = name.to_s
      sensor.vm.network :private_network, type: :dhcp
      sensor.vm.provision "shell", path: "start.sh"
    end

    config.vm.provision "shell", path: "provisioning.sh", args: "#{sensors[name]}"
  end

end
