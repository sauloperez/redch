Vagrant.configure("2") do |config|
  config.vm.box = "precise32"
  config.vm.provision :shell, :path => "provisioning.sh"

  config.vm.define :sensor0 do |sensor0_config|
    sensor0_config.vm.host_name = "sensor0"
    sensor0_config.vm.network :private_network, ip: "192.168.0.2"
  end

  # config.vm.define "sensor1" do |sensor1|
  #  sensor1.vm.network :private_network, ip: "192.168.0.3"
  # end
end
