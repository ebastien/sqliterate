# coding: utf-8

describe SQLiterate::LiteralsParser do
  def parse(q)
    SQLiterate::LiteralsParser.new.parse q
  end

  def should_parse(q)
    r = parse q
    expect(r).not_to be_nil
    r
  end

  def should_reject(q)
    expect(parse q).to be_nil
  end

  it "parses an integer" do
    should_parse("42")
  end

  it "parses a boolean" do
    should_parse("true")
  end

  it "parses a string" do
    should_parse("'42'")
  end

  it "parses a float" do
    should_parse("42.56")
    should_parse(".56")
  end

  it "parses an exponent notation" do
    should_parse("42.56e-3")
    should_parse("42.e3")
  end

  it "parses typed strings" do
    pending("not implemented")
    should_parse("timestamp '2004-10-19 10:23:54+02'")
    should_parse("TIMESTAMP WITH TIME ZONE '2004-10-19 10:23:54+02'")
    should_parse("time '04:05:06-08:00'")
    should_parse("time (4) without time zone '04:05 PM'")
    should_parse("DATE 'January 8, 1999'")
    should_parse("interval(3) '10 days 2:03:04' DAY TO SECOND")
    should_parse("bigint '12'")
    should_parse("int8 '12'")
    should_parse("boolean 'true'")
    should_parse("bool 'true'")
    should_parse("character(3) 'abc'")
    should_parse("char(3) 'abc'")
    should_parse("character varying (10) 'abcd'")
    should_parse("varchar(10) 'abcd'")
    should_parse("double precision '1.23'")
    should_parse("float8 '1.23'")
    should_parse("integer '42'")
    should_parse("int '42'")
    should_parse("int4 '42'")
    should_parse("numeric(10,2) '1.23'")
    should_parse("decimal (10,2) '1.23'")
    should_parse("real '1.23'")
    should_parse("float4 '1.23'")
    should_parse("smallint '42'")
    should_parse("int2 '42'")
    should_parse("text 'some text'")
  end
end
