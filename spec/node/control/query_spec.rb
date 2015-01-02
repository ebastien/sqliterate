# coding: utf-8
require "#{File.dirname(__FILE__)}/../../spec_helper"

describe "tables access control" do
  def parse(q)
    r = Sqliterate::QueryParser.new.parse q
    expect(r).not_to be_nil
    r.tables
  end

  it "parses select without from clause" do
    expect(parse("select 42")).to be_empty
  end

  it "parses select with from clause" do
    expect(parse("select a from t")).to eq(["t"])
  end

  it "parses select with two tables" do
    expect(parse("select a from t1, t2")).to eq(["t1","t2"])
  end

  it "parses select with subquery" do
    expect(parse("select a from t1, (select b,c from d.t) t2")).to eq(["d.t","t1"])
  end

  it "parses select with natural join" do
    expect(parse("select a,b from t1 natural inner join t2")).to eq(["t1","t2"])
  end

  it "parses select with multiple joins" do
    expect(parse("select a,b from t1 join t2 using (a) right join t3 on (t2.b = t3.c)")).to \
     eq(["t1","t2","t3"])
  end

  it "parses select with common table expression" do
    expect(parse("with q as (select a,b from t1) select a,b,c from q natural join t2")).to \
     eq(["t1","t2"])
  end

  it "parses select with common table expression and join" do
    expect(parse("with q as (select a,b from t1 natural join t2) select c from q natural join t3")).to \
     eq(["t1","t2","t3"])
  end

  it "parses select with common table expression and repeated table" do
    expect(parse("with q as (select a,b from t1 natural join t2) select c from q natural join t2")).to \
     eq(["t1","t2"])
  end

  it "parses combined select queries" do
    expect(parse("select a from t1 union (select b from t2 union select c from t3)")).to \
     eq(["t1","t2","t3"])
  end

  it "parses select with subquery" do
    expect(parse("select a, 2 + (select max(b) from t2) from t1")).to eq(["t1","t2"])
  end
end
