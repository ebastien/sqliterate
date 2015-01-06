# coding: utf-8

describe SQLiterate::CommentParser do
  def parse(q)
    SQLiterate::CommentParser.new.parse q
  end

  def should_parse(q)
    r = parse q
    expect(r).not_to be_nil
    r
  end

  def should_reject(q)
    expect(parse q).to be_nil
  end

  it "parses a C comment" do
    should_parse "/* a comment */"
  end

  it "parses a nested C comment" do
    should_parse "/* a /* nested */ comment */"
  end

  it "rejects an invalid C comment" do
    should_reject "/* an /* invalid comment */"
  end

  it "parses a line comment" do
    should_parse "-- a line -- comment\n"
  end

  it "rejects an invalid line comment" do
    should_reject "-- an invalid line \n comment\n"
  end
end
