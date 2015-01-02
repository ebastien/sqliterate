# coding: utf-8
require "#{File.dirname(__FILE__)}/../../spec_helper"

describe "identifier name" do
  def parse(q)
    r = SQLiterate::IdentifierParser.new.parse q
    expect(r).not_to be_nil
    r.name
  end

  it "parses simple identifier" do
    expect(parse("my_$IdenTifieR_éあいうï")).to eq("my_$IdenTifieR_éあいうï")
  end

  it "parses quoted identifier" do
    expect(parse("\"select\"")).to eq("select")
  end
end
