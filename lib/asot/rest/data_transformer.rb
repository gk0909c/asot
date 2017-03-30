module Asot
  module Rest
    # mutual tranformer about salesforce rest api data
    module DataTransformer
      Target = Struct.new(:obj, :id)

      module_function

      def transform_delete_batch(data)
        data.inject([]) do |batches, target|
          batch = {
            method: 'DELETE',
            url: format('/v%.1f/sobjects/%s/%s', API_VERSION, target.obj, target.id)
          }
          batches.push(batch)
        end
      end
    end
  end
end
