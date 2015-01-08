# coding: utf-8

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

  it "parses case expressions" do
    should_parse("case when a=1 then 'one' when a=2 then 'two' end")
    should_parse("case when a=1 then 'one' when a=2 then 'two' else 'other' end")
    should_parse("case when a=1 then 'one' end")
  end

  it "parses between expressions" do
    should_parse("a between x and y")
    should_parse("a not between x and y")
    should_parse("a between symmetric x and y")
    should_parse("a between x and y between x and y")
  end

  it "parses test expressions" do
    should_parse("a is null")
    should_parse("a is not null")
    should_parse("a isnull")
    should_parse("a notnull")
    should_parse("a is distinct from b")
    should_parse("a is not distinct from b")
    should_parse("a is true")
    should_parse("a is not true")
    should_parse("a is false")
    should_parse("a is not false")
    should_parse("a is unknown")
    should_parse("a is not unknown")
  end

  it "parses overlaps expressions" do
    pending('not implemented')
    should_parse(
      "(DATE '2001-02-16', DATE '2001-12-21') OVERLAPS (DATE '2001-10-30', DATE '2002-10-30')")
  end

  it "parses pattern matching expressions" do
    pending('not implemented')
    should_parse("'text' like '_pattern%'")
    should_parse("'text' not like '_pattern%'")
    should_reject("not 'text' like '_pattern%'")
    should_parse("'text' like '_pattern%' escape '!'")
    should_parse("'text' ilike '_pattern%'")
    should_parse("'text' similar to '_(patt|ern)%'")
    should_parse("'text' not similar to '_(patt|ern)%'")
    should_parse("substring('foobar' from '%#\"o_b#\"%' for '#')")
    should_parse("substring('foobar' from 'o.b')")
  end

  it "parses membership expressions" do
    should_parse("EXISTS (SELECT 1 FROM tab2 WHERE col2 = tab1.col2)")
    should_parse("a in (select b from t)")
    should_parse("a NOT IN (select b from t)")
    should_parse("a in (10,20,30)")
    should_parse("a not in ('a', 'b', 'c')")
  end

  it "parses set predicate expressions" do
    pending('not implemented')
    should_parse("a > ANY (select b from t)")
    should_parse("a = some (select b from t)")
    should_parse("a <> all (select b from t)")
  end

  it "parses date/time constructs" do
    pending('not implemented')
    should_parse("EXTRACT(CENTURY FROM TIMESTAMP '2000-12-16 12:21:13')")
    should_parse("TIMESTAMP '2001-02-16 20:38:40' AT TIME ZONE 'MST'")
  end
end
