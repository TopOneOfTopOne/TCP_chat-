require 'socket'
require_relative 'ip_finder'

=begin
has previews
	connections: {
		clients: { client_name: {attr} }
		rooms: { room_name: [client_names] }
	}
=end

class Server
	def initialize(hostname, port)
    puts 'Server started...'
		@server      = TCPServer.open(hostname, port)
		@rooms       = {}
		@clients     = {}
    @log         = File.open("#{File.expand_path(File.dirname(__FILE__))}/log/log.txt",'a+')
    @connections = {
        server: @server,
        clients: @clients,
        rooms: @rooms
    }
    run
	end

	def run
    loop do
      Thread.start(@server.accept) do |client|
        puts "#{client} attempting to connect"
        client_name = get_client_name(client)
        puts "#{client_name}: #{client} joined"
        write_to_log("#{client_name} #{client} joined on: (#{Time.now})")
        @connections[:clients][client_name] = client
        client.puts "Connection Established #{client_name}"
        listen_user_msg(client_name, client)
      end
    end.join
end

  def get_client_name(client)
    loop do
      client_name = client.gets.chomp.to_sym
      return client_name unless client_name_exists?(client_name)
      client.puts 'Name already exists try again'
    end
  end

  def client_name_exists?(client_name)
    @connections[:clients].each {|c_n, _| return true if c_n == client_name}
    false
  end

  def listen_user_msg(client_name, client)
    loop do
      msg = client.gets.chomp
      puts "received (#{msg}) from: #{client_name}"
      display_msg_to_all_clients(msg, client_name)
    end
  end

  def display_msg_to_all_clients(msg, client_name)
    @connections[:clients].each {|c_n, c| c.puts "<#{client_name}> #{msg}" unless c_n == client_name}
  end

  def write_to_log(text)
    puts "Attempting to write to log"
    @log.puts text
    @log.close
  end
end

hostname = IP_FIND.get_first_ip
Server.new(hostname, 2000)