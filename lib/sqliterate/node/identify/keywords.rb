module SQLiterate
  module Node
    module TypeName
      def name
        text_value.to_sym
      end
    end
  end
end
