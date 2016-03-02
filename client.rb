require 'socket'

class Client 
	def initialize(hostname, port)
		@server = TCPSocket.open(hostname, port)
		@request = nil 
		@response = nil
    send
    listen
    @request.join
    @response.join
	end

	def send
    puts 'Enter username: ' # first run will always require user to input username
    @request = Thread.new do
      loop do
        msg = gets.chomp
        @server.puts msg
      end
    end
  end

  def listen
    @response = Thread.new do
      loop do
        msg = @server.gets.chomp
        puts "#{msg}"
      end
    end
  end
end

server_ip = '192.168.1.7'
port      = 2000 
Client.new(server_ip, port)