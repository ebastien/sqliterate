# coding: utf-8

describe SQLiterate::CommandParser do
  def should_parse(q)
    r = SQLiterate::CommandParser.new.parse q
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
