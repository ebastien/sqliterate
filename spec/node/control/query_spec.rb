# coding: utf-8

describe "tables access control" do
  def parse(q)
    r = SQLiterate::QueryParser.new.parse q
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

  it "parses select with subquery in sort expression" do
    expect(parse("select a from t1 order by (select avg(b+a) from t2)")).to eq(["t1","t2"])
  end

  it "parses select with subquery in where clause" do
    expect(parse("select a from t1 where a > (select max(b) from t2)")).to eq(["t1","t2"])
  end

  it "parses select with subquery in group by clause" do
    expect(parse("select a from t1 group by a, (select avg(b+a) from t2)")).to eq(["t1","t2"])
    expect(parse("select a from t1 group by a having a > (select avg(b) from t2)")).to eq(["t1","t2"])
  end

  it "parses select with subquery in case expression" do
    expect(parse("select case when (select max(b) from t1) > a then c end from t2")).to eq(["t1","t2"])
    expect(parse("select case when a > 0 then (select max(b) from t1) end from t2")).to eq(["t1","t2"])
    expect(parse("select case when a > 0 then c else (select max(b) from t1) end from t2")).to eq(["t1","t2"])
  end

  it "parses select with subquery in between expression" do
    expect(parse("select (select max(a) from t1) between (select max(b) from t2) and (select max(c) from t3)")).to \
      eq(["t1","t2","t3"])
  end

  it "parses select with subquery in test expression" do
    expect(parse("select (select max(a) from t1) is distinct from (select max(b) from t2)")).to \
      eq(["t1","t2"])
  end

  it "parses select with subquery in limit and offset" do
    expect(parse("select * from t1 limit (select max(b) from t2) offset (select min(c) from t3)")).to \
      eq(["t1","t2","t3"])
  end

  it "parses select with subquery in membership list" do
    expect(parse("select 1 in ((select max(b) from t1),(select min(c) from t2))")).to \
      eq(["t1","t2"])
  end

  it "parses select with subquery in set predicate expression" do
    expect(parse("select 1 not in (select b from t)")).to eq(["t"])
    expect(parse("select 1 > some (select b from t)")).to eq(["t"])
  end

  it "parses select with subquery in set membership expression" do
    expect(parse("select a from t1 where exists (select 1 from t2 where b > a)")).to \
      eq(["t1","t2"])
  end
end
