# coding: utf-8
require "#{File.dirname(__FILE__)}/../spec_helper"

describe SQLiterate::StringParser do
  def should_parse(q)
    r = SQLiterate::StringParser.new.parse(q)
    expect(r).not_to be_nil
    r
  end

  it "parses a string" do
    should_parse("'string'")
  end

  it "parses a string with escaped quote" do
    should_parse("'str''ing'")
  end

  it "parses a string in parts" do
    should_parse("'str' \n 'ing'")
  end

  it "parses an extended string" do
    should_parse("E's\\tr''i\\ng'")
  end

  it "parses a string with octal char value" do
    should_parse("e's\\123g'")
  end

  it "parses a string with hexa char value" do
    should_parse("e's\\x7Fg'")
  end

  it "parses a string with hexa char value" do
    should_parse("e's\\x1g'")
  end

  it "parses a string with unicode char value" do
    should_parse("e's\\u007Fg'")
  end

  it "parses a string with unicode char value" do
    should_parse("e's\\u0000007Fg'")
  end
end
