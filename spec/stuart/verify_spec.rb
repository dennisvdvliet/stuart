require 'spec_helper'

describe Stuart::Verify do
  let(:signed_request) { Stuart::Request.new({
    headers: {
      'Authorization' => 'Signature keyId="booking_web_hooks",algorithm="rsa-sha256",headers="host url method date content-type body",delimiter="|",signature="QA2+OK+k2DrQ0pYIN6hnGn3n0hGcxMRUxMEJEzFKHSUp5671S0F2717HLtnbS64p1igT9pXom0FcTOm4aYF+66qZeps6VD18A8A0AEDVY+avfG+LiHNrD4Fl2yZ0qkykh5BQ2VI1/4PVjGktAc2//EX2WDMkn9G5+U6FWstVSSd3BJ0ZYSNN5DmLyRLXaB+PCgzqHA2Ojjc8zifGB0/r7xBLXZb18nrnKIocKhApZyEekAkxJNdrRAHi7VKZp3kGyKei3mZE/NzllBUoRfMERuct7d0/aWVCg0xqYcdTYohXPHS0zaMENYrjU90sc0K55mXIVYFLNvdAXdODvmsQTw=="',
      'Content-Type' => 'application/json',
      'Date' => 'Sat, 20 Jun 2015 00:47:57 GMT',
      'Host' => 'example.org:123'
    },
    body: '{ "payload" : "test" }',
    host: nil,
    path: '/foo',
    method: 'POST'})}

  let(:public_key) {
    ' -----BEGIN PUBLIC KEY-----
      MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArEzC0MAU1MrmYjwwscW2
      HbQgegnEbe6CZEroQ7nFMmOARdeiw7X9QOENQDe5pvK1o7tdYAvNpg5BRWTq90v+
      UShZ4kqni1YaNXEZgeN7alR2m/KRP4lBRpVnBV11cVd7/lmLP3ux23AksDubh/Sj
      CXkikx78pnof3itCLQqDAxBLCYPo3a4i54lniwDjeJS91Fto4c4ERr7CFD5EQih3
      mC5z6zwPYpe53ZZTbFRMf1IG7QdhfiMoZQ7YAgMLZj8i9oJHuB4rV5zCNtJ7LNni
      2hS20bGymsW93lhE1jtBx7RdTD1NCUGDOt3jOAjFEL2wGjNYiHictWdvpWR2v8Ym
      owIDAQAB
      -----END PUBLIC KEY-----'}

  describe "#verify" do
    it "returns true" do
      expect(described_class.new(request: signed_request, public_key: public_key).verify).to eq(true)
    end
  end
end
