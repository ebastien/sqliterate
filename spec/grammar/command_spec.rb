# coding: utf-8
require "#{File.dirname(__FILE__)}/../spec_helper"

describe Sqliterate::CommandParser do
  def should_parse(q)
    r = Sqliterate::CommandParser.new.parse q
    expect(r).not_to be_nil
    r
  end

  it "parses a single query" do
    should_parse "select a;"
  end

  it "parses multiple queries" do
    should_parse "select a; select b"
  end

  it "parses queries with comment" do
    should_parse "select /* comment */ a; select b"
  end
end
