#!/usr/bin/ruby

require 'net/http'
require 'net/https'
require 'uri'
require 'json'

namespace = ENV['OPENSHIFT_BUILD_NAMESPACE']
token = File.new("/var/run/secrets/kubernetes.io/serviceaccount/token", "r").read
#token="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJsb2dnZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlY3JldC5uYW1lIjoiZGVmYXVsdC10b2tlbi1hdzAyOCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiMDFlOWQ3ODItNzAyMC0xMWU1LWJlZTctMDAxZGQ4YjcxYzc2Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OmxvZ2dlcjpkZWZhdWx0In0.IK2DfvbThCkroCGVmBaz5H8PmfjQzB9V_q4CpppyyEzc0PLR-UdqPRBnwkf_tO8CKb9aEz44pp1g_nkNVdPyK6VUCT7N-sQVlDyOQZoE4VBVNHcw5Dz3OqxTlysIbO50f9UtyNIWnbr32XuqYGdWXTbxzjaGzjlr3bmA1s6MiRrgn-qZeGuUoANVUyVScCqjaWK4iNvO-5HiXcpAdq6lag5OsMZ1RCQf2XqF_8WzU7-oCZnbo5mwStAy7WN5Alw5hB_cvdsyp8cTa5rvnyjhnWP2OGVP_I3nUI43MevyzzL-hTFO0wjNZfVSq1WV7qE3TareBt1bKTAjNYLt2TCl5g"

url = URI.parse("https://mgmxasmastert01.infra.rit-paas.com:8443/api/v1/namespaces/#{namespace}/endpoints")

http =  Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

req = Net::HTTP::Get.new(url.to_s, {"Authorization" => "Bearer #{token}"})
resp = http.start{|http| http.request(req)}

parsed = JSON.parse(resp.body)

eps = Array.new
parsed["items"][0]["subsets"][0]["addresses"].each do |ep|
  eps << ep["ip"]
end

puts eps.join ","
