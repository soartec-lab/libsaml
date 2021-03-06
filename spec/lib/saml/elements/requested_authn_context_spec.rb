require 'spec_helper'

describe Saml::Elements::RequestedAuthnContext do
  let(:requested_authn_context) { FactoryBot.build(:requested_authn_context) }

  describe "Required fields" do
    [:authn_context_class_ref].each do |field|
      it "should have the #{field} field" do
        expect(requested_authn_context).to respond_to(field)
      end

      it "should check the presence of #{field}" do
        requested_authn_context.send("#{field}=", nil)
        expect(requested_authn_context).not_to be_valid
      end
    end
  end

  describe "Comparison" do
    it "should allow comparison to be invalid" do
      requested_authn_context.comparison = "invalid"
      expect(requested_authn_context).not_to be_valid
    end
  end

  describe "#parse_xml" do

    let(:authn_request_xml) { File.read(File.join('spec', 'fixtures', 'authn_request.xml')) }
    let(:authn_request) { Saml::AuthnRequest.parse(authn_request_xml) }

    let(:requested_authn_context) { Saml::Elements::RequestedAuthnContext.parse(authn_request_xml).first }

    it "should create a new Saml::Elements::RequestedAuthnContext" do
      expect(requested_authn_context).to be_a(Saml::Elements::RequestedAuthnContext)
    end

    it "should parse the comparison" do
      expect(requested_authn_context.comparison).to eq("minimum")
    end

    it "should parse the AuthnContextClassRef" do
      expect(requested_authn_context.authn_context_class_ref).to eq("urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport")
    end

  end
end
