module Remarkable::Mongoid
  module Matchers
    def reference_one(attr)
      AssociationMatcher.new(attr, ::Mongoid::Relations::Referenced::One)
    end

    def reference_many(attr)
      AssociationMatcher.new(attr, ::Mongoid::Relations::Referenced::Many)
    end

    def reference_many_as_array(attr)
      AssociationMatcher.new(attr, ::Mongoid::Relations::Referenced::ManyAsArray)
    end

    def be_referenced_in(attr)
      AssociationMatcher.new(attr, ::Mongoid::Relations::Referenced::In)
    end

    def embed_one(attr)
      AssociationMatcher.new(attr, ::Mongoid::Relations::Embedded::One)
    end

    def embed_many(attr)
      AssociationMatcher.new(attr, ::Mongoid::Relations::Embedded::Many)
    end

    def be_embedded_in(attr)
      AssociationMatcher.new(attr, ::Mongoid::Relations::Embedded::In)
    end

    class AssociationMatcher
      attr_accessor :attr, :relation_type

      def initialize(attr, relation_type)
        self.attr             = attr.to_s
        self.relation_type = relation_type
      end

      def matches?(subject)
        @subject     = subject
        relations = @subject.relations.select { |k,v| v.relation == relation_type }
        relations.detect { |k| k.first == attr } != nil
      end

      def description
        "has #{humanized_association} association :#{attr}"
      end

      def failure_message_for_should
        "\n#{humanized_association} association failure\nExpected: '#{attr}'"
      end

      private

      def humanized_association
        relation_type.to_s.split('::').last
      end
    end
  end
end
