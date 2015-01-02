# coding: utf-8
require "#{File.dirname(__FILE__)}/../../spec_helper"

describe "operator evaluation" do
  def parse(q)
    r = Sqliterate::OperatorParser.new.parse q
    expect(r).not_to be_nil
    r.operator
  end

  it "parses operators" do
    expect(parse("=!=")).to eq(:"=!=")
    expect(parse("<~&")).to eq(:"<~&")
    expect(parse("</*~&*/")).to eq(:"<")
    expect(parse("</*~&*/!")).to eq(:"<!")
    expect(parse("<--~&")).to eq(:"<")
    expect(parse("<?-")).to eq(:"<?-")
    expect(parse("/")).to eq(:"/")
    expect(parse("!")).to eq(:"!")
    expect(parse("/>")).to eq(:"/>")
    expect(parse("+")).to eq(:"+")
    expect(parse("<!>++")).to eq(:"<!>++")
    expect(parse("<!>+=")).to eq(:"<!>+=")
  end
end
