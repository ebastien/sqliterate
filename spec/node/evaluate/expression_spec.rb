# coding: utf-8
require "#{File.dirname(__FILE__)}/../../spec_helper"

describe "expression evaluation" do
  def parse(q)
    r = Sqliterate::ExpressionParser.new.parse q
    expect(r).not_to be_nil
    r.value
  end

  it "parses a column name" do
    expect(parse("a")).to eq(["a"])
  end

  it "parses a qualified column name" do
    expect(parse("my_table.my_column")).to eq([[:f, "my_table", "my_column"]])
  end

  it "parses an integer" do
    expect(parse("42")).to eq([42])
  end

  it "parses a boolean" do
    expect(parse("true")).to eq([true])
  end

  it "parses a string" do
    expect(parse("'42'")).to eq(["42"])
  end

  it "parses a float" do
    expect(parse("42.56")).to eq([42.56])
    expect(parse(".56")).to eq([0.56])
  end

  it "parses an exponent notation" do
    expect(parse("42.56e-3")).to eq([0.04256])
    expect(parse("42.e3")).to eq([42000])
  end

  it "parses expression with ambiguous operators" do
    expect(parse("1>=-3")).to eq([1.0, :">=", :-, 3.0])
    expect(parse("1>!-3")).to eq([1.0, :">!-", 3.0])
  end

  it "parses a scalar subquery" do
    e = parse("(SELECT max(pop) FROM cities WHERE cities.state = states.name)")
    expect(e).to eq(["SELECT max(pop) FROM cities WHERE cities.state = states.name"])
  end
end
