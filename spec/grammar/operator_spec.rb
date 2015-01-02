# coding: utf-8
require "#{File.dirname(__FILE__)}/../spec_helper"

describe SQLiterate::OperatorParser do
  def parse(q)
    SQLiterate::OperatorParser.new.parse q
  end

  def should_parse(q)
    r = parse q
    expect(r).not_to be_nil
    r
  end

  def should_reject(q)
    expect(parse q).to be_nil
  end

  it "parses operators" do
    should_parse("=!=")
    should_parse("<~&")
    should_parse("</*~&*/")
    should_parse("</*~&*/!")
    should_parse("<--~&")
    should_parse("<?-")
    should_parse("/")
    should_parse("!")
    should_parse("/>")
    should_parse("+")
    should_parse("<!>++")
    should_parse("<!>+=")
  end

  it "rejects invalid operators" do
    should_reject(">=-")
  end
end
