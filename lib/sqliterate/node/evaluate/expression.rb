module SQLiterate
  module Node
    module DisjunctionExpression
      def value
        if r.empty?
          e.value
        else
          [:or, e.value ] + r.elements.flat_map { |e| e.e.value }
        end
      end
    end

    module ConjunctionExpression
      def value
        if r.empty?
          e.value
        else
          [:and, e.value ] + r.elements.flat_map { |e| e.e.value }
        end
      end
    end

    module NegationExpression
      def value
        respond_to?(:not_kw) ? [:not, e.value] : e.value
      end
    end

    module BetweenExpression
      def value
        if r.empty?
          gen_expression.value
        else
          [:b, gen_expression.value] + r.elements.flat_map do |e|
            [e.l.value, e.r.value]
          end
        end
      end
    end

    module GenExpression
      def value
        h.elements.map { |e| e.gen_operator.operator } +
        [gen_value.value] +
        r.elements.flat_map do |e|
          e.o.elements.map { |p| p.gen_operator.operator } + [e.gen_value.value]
        end +
        t.elements.map { |e| e.gen_operator.operator }
      end
    end

    module GenValue
      module Subscript
        def value
          [:s, field_selection.value] + r.elements.map do |e|
            e.range_expression.value
          end
        end
      end
    end

    module FunctionCall
      def value
        [function_name.name] + function_params.value
      end
    end

    module TypeCast
      def value
        [type_name.name, scalar_expression.value]
      end
    end

    module VoidExpression
      def value
        []
      end
    end

    module AggregateExpression
      def value
        [:a, expressions_list.value, order_by_clause.value]
      end
    end

    module OrderByClause
      def value
        respond_to?(:expressions_list) ? expressions_list.value : nil
      end
    end

    module ExpressionsList
      def value
        [scalar_expression.value] + r.elements.map do |e|
          e.scalar_expression.value
        end
      end
    end

    module NamedExpressionsList
      def value
        [named_expression.value] + r.elements.map do |e|
          e.named_expression.value
        end
      end
    end

    module NamedExpression
      def value
        if respond_to?(:column_name)
          [column_name.name, scalar_expression.value]
        else
          scalar_expression.value
        end
      end
    end

    module AllColumns
      def value
        [:all]
      end
    end

    module RangeExpression
      def value
        [:r, b.value, e.value]
      end
    end

    module FieldSelection
      def value
        [:f, row_value.value, field_identifier.name]
      end
    end

    module RowValue
      module Query
        def value
          query_expression.text_value
        end
      end
      module Expression
        def value
          scalar_expression.value
        end
      end
      module Positional
      end
      module Identifier
        def value
          name
        end
      end
    end
  end
end
