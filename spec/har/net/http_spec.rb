# frozen_string_literal: true

require "json"
require "webrick"
require "webrick/https"
require "har/net/http"

module WEBrick
  module HTTPServlet
    class ProcHandler < AbstractServlet
      alias do_PUT do_GET # Webrick #mount_proc only works with GET,HEAD,POST,OPTIONS by default
    end
  end
end

RSpec.shared_context "HTTP Server" do
  def start_server(protocol)
    uri = URI("#{protocol}://localhost")

    rd, wt = IO.pipe
    webrick_options = {
      Port: 0,
      Logger: WEBrick::Log.new(File.open(File::NULL, "w")),
      AccessLog: [],
      StartCallback: proc do
        wt.write(1) # write "1", signal a server start message
        wt.close
      end
    }
    if uri.scheme == "https"
      webrick_options[:SSLEnable] = true
      # Set up a self-signed cert
      webrick_options[:SSLCertName] = [%w[CN localhost]]
    end

    @server = WEBrick::HTTPServer.new(webrick_options)

    @server.mount_proc "/sleep" do |_req, res|
      duration = 0.3
      sleep duration
      res.status = 200
      res.body = "I slept for #{duration} s"
    end

    Thread.new do
      @server.start
    end
    rd.read(1) # read a byte for the server start signal
    rd.close

    "#{protocol}://localhost:#{@server.config[:Port]}"
  end

  after do
    @server&.shutdown
  end
end

RSpec.describe Har::Net::HTTP do
  include_context "HTTP Server"

  before do
    Har::Net::HTTP.har = nil
  end

  it "captures a HAR" do
    url = start_server("http")
    Net::HTTP.get(URI("#{url}/sleep"))

    entry = Har::Net::HTTP.har[:log][:entries][0]
    expect(entry[:request][:method]).to eq("GET")
  end
end
