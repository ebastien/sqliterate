# coding: utf-8
require "#{File.dirname(__FILE__)}/../spec_helper"

describe Sql::StringParser do
  def parse(q)
    r = Sql::StringParser.new.parse(q)
    expect(r).not_to be_nil
    r
  end

  it "parses a string" do
    parse("'string'")
  end

  it "parses a string with escaped quote" do
    parse("'str''ing'")
  end

  it "parses a string in parts" do
    parse("'str' \n 'ing'")
  end

  it "parses an extended string" do
    parse("E's\\tr''i\\ng'")
  end

  it "parses a string with octal char value" do
    parse("e's\\123g'")
  end

  it "parses a string with hexa char value" do
    parse("e's\\x7Fg'")
  end

  it "parses a string with hexa char value" do
    parse("e's\\x1g'")
  end

  it "parses a string with unicode char value" do
    parse("e's\\u007Fg'")
  end

  it "parses a string with unicode char value" do
    parse("e's\\u0000007Fg'")
  end
end
