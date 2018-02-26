require 'spec_helper'

describe Stuart::Request do
  let(:invalid_signed_request) {{headers: {'Authorization' => 'Signature yolo'}, body: nil, host: nil, path: nil, method: nil}}
  let(:signed_request) {{
    headers: {
      'Authorization' => 'Signature keyId="booking_web_hooks",algorithm="rsa-sha256",headers="host url method date content-type body",delimiter="|",signature="QA2+OK+k2DrQ0pYIN6hnGn3n0hGcxMRUxMEJEzFKHSUp5671S0F2717HLtnbS64p1igT9pXom0FcTOm4aYF+66qZeps6VD18A8A0AEDVY+avfG+LiHNrD4Fl2yZ0qkykh5BQ2VI1/4PVjGktAc2//EX2WDMkn9G5+U6FWstVSSd3BJ0ZYSNN5DmLyRLXaB+PCgzqHA2Ojjc8zifGB0/r7xBLXZb18nrnKIocKhApZyEekAkxJNdrRAHi7VKZp3kGyKei3mZE/NzllBUoRfMERuct7d0/aWVCg0xqYcdTYohXPHS0zaMENYrjU90sc0K55mXIVYFLNvdAXdODvmsQTw=="',
      'Content-Type' => 'application/json',
      'Date' => 'Sat, 20 Jun 2015 00:47:57 GMT',
      'Host' => 'example.org:123'
    },
    body: '{ "payload" : "test" }',
    host: nil,
    path: '/foo',
    method: 'POST'}}

  let(:invalid_unsigned_request) {{headers: {}, body: nil, host: nil, path: nil, method: nil}}
  let(:valid_request) {}
  describe "public api" do
    describe "#signed?" do
      context "unsigned request" do
        it "returns false" do
          expect(described_class.new(invalid_unsigned_request).signed?).to eq(false)
        end
      end
      context "signed request" do
        it "returns true" do
          expect(described_class.new(invalid_signed_request).signed?).to eq(true)
        end
      end
    end
  end

  describe "#signature" do
    it "returns QA2+OK+k2DrQ0pYIN6hnGn3n0hGcxMRUxMEJEzFKHSUp5671S0F2717HLtnbS64p1igT9pXom0FcTOm4aYF+66qZeps6VD18A8A0AEDVY+avfG+LiHNrD4Fl2yZ0qkykh5BQ2VI1/4PVjGktAc2//EX2WDMkn9G5+U6FWstVSSd3BJ0ZYSNN5DmLyRLXaB+PCgzqHA2Ojjc8zifGB0/r7xBLXZb18nrnKIocKhApZyEekAkxJNdrRAHi7VKZp3kGyKei3mZE/NzllBUoRfMERuct7d0/aWVCg0xqYcdTYohXPHS0zaMENYrjU90sc0K55mXIVYFLNvdAXdODvmsQTw==" do
      expect(described_class.new(signed_request).signature).to eq('QA2+OK+k2DrQ0pYIN6hnGn3n0hGcxMRUxMEJEzFKHSUp5671S0F2717HLtnbS64p1igT9pXom0FcTOm4aYF+66qZeps6VD18A8A0AEDVY+avfG+LiHNrD4Fl2yZ0qkykh5BQ2VI1/4PVjGktAc2//EX2WDMkn9G5+U6FWstVSSd3BJ0ZYSNN5DmLyRLXaB+PCgzqHA2Ojjc8zifGB0/r7xBLXZb18nrnKIocKhApZyEekAkxJNdrRAHi7VKZp3kGyKei3mZE/NzllBUoRfMERuct7d0/aWVCg0xqYcdTYohXPHS0zaMENYrjU90sc0K55mXIVYFLNvdAXdODvmsQTw==')
    end
  end

  describe "#cleaned_authorization_header" do
    it "returns yolo" do
      expect(described_class.new(invalid_signed_request).send(:cleaned_authorization_header)).to eq('yolo')
    end
  end

  describe "#payload" do
    it "returns correct payload" do
      expect(described_class.new(signed_request).send(:payload)).to eq('example.org|/foo|POST|Sat, 20 Jun 2015 00:47:57 GMT|application/json|{ "payload" : "test" }')
    end
  end

  describe "#authorization_header" do
    it "returns a hash" do
      expect(described_class.new(signed_request).send(:authorization_header)).to have_key(:keyId)
    end
  end
end
