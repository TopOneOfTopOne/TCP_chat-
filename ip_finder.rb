require 'socket'

module IP_FIND
	def self.private_ipv4
	  Socket.ip_address_list.select{|intf| intf.ipv4_private?}
	end

	def self.public_ipv4
	  Socket.ip_address_list.select{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast? and !intf.ipv4_private?}
	end

	def self.get_first_ip
		private_ipv4.first.ip_address 
	end
end

