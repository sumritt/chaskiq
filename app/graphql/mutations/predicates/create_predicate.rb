module Mutations
  class Predicates::CreatePredicate < Mutations::BaseMutation
    # TODO: define return fields
    # field :post, Types::PostType, null: false
    field :segment, Types::SegmentType, null: false
    field :errors, Types::JsonType, null: true
    
    argument :predicates, Types::JsonType, required: true
    argument :id, Integer, required: false
    argument :app_key, String, required: false

    argument :name, String, required: false
    argument :operation, String, required: false
    argument :predicates, Types::JsonType, required: false

    def resolve(app_key:, name: , operation:, predicates: )
      current_user = context[:current_user]
      @app = current_user.apps.find_by(key: app_key)

      @segment = @app.segments.new
      @segment.name = name
      @segment.predicates = predicates.map(&:permit!).as_json

      if operation.present? and operation == "create"
        @segment.save      
      end

      { segment: @segment, errors: @segment.errors }
    end
  end

end