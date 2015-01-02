# coding: utf-8
require "#{File.dirname(__FILE__)}/../spec_helper"

describe SQLiterate::ExpressionParser do
  def parse(q)
    SQLiterate::ExpressionParser.new.parse q
  end

  def should_parse(q)
    r = parse q
    expect(r).not_to be_nil
    r
  end

  def should_reject(q)
    expect(parse q).to be_nil
  end

  it "parses a column name" do
    should_parse("a")
  end

  it "parses a qualified column name" do
    should_parse("my_table.my_column")
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

  it "parses arithmetic" do
    should_parse("-42 * (3.5 - 9 / t.b) + t.a")
  end

  it "parses diverse scalar expressions" do
    should_parse("1+-3")
    should_parse("+1*-3")
    should_parse("+1>-3")
    should_parse("+1>*3")
    should_parse("+1>!-3")
    should_parse("+1>-2==-3")
    should_reject("1 2")
    should_reject("+")
    should_reject("3_2")
    should_reject("*")
  end

  it "parses expression with ambiguous operators" do
    should_parse("1>=-3")
    should_parse("1>!-3")
  end

  it "parses positional parameters" do
    should_parse("$1 + $2")
  end

  it "parses subscript expressions" do
    should_parse("table.column[42 + 1]")
    should_parse("mytable.arraycolumn[4]")
    should_parse("mytable.two_d_column[17][34]")
    should_parse("$1[10:42]")
    should_parse("(arrayfunction(a,b))[42]")
  end

  it "parses function calls" do
    should_parse("sqrt(2)")
    should_parse("somefunction(2,42, \"some, string\")")
  end

  it "parses field selections" do
    should_parse("$1.somecolumn")
    should_parse("(compositecol).somecolumn")
    should_parse("(compositecol).*")
    should_parse("(rowfunction(a,b)).col3")
    should_parse("(compositecol).somefield")
    should_parse("(mytable.compositecol).somefield")
    should_parse("(select a,b from t).a")
  end

  it "parses aggregate function calls" do
    should_parse("array_agg(a ORDER BY b,c)")
    should_parse("array_agg(ALL a, b ORDER BY c DESC)")
    should_parse("array_agg(DISTINCT a ORDER BY b ASC)")
    should_parse("array_agg(*)")
    should_parse("string_agg(a, ',' ORDER BY a)")
  end

  it "parses type casts" do
    should_parse("CAST( a AS integer )")
  end

  it "parses logical expressions" do
    should_parse("a AND b OR NOT c")
  end

  it "parses a scalar subquery" do
    should_parse("(SELECT max(pop) FROM cities WHERE cities.state = states.name)")
  end
end
