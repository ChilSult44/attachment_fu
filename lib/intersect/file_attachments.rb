module Intersect::FileAttachments
  
  def self.included(included_into)
    
    included_into.module_eval do
      has_many :files, :class_name => "#{self.name}File"
      after_save :save_attachments

      def attachable=(params)
        @attachments = params.keys.sort.inject([]) { |vals, k| vals.push(params[k]) }.reject {|a| a[:uploaded_data].blank? }.collect { |a| "#{self.class.name}File".constantize.new(a) }
      end

      protected
      def save_attachments
        if @attachments
          @attachments.each do |attachment|
            files << attachment
          end
        end
      end
      
    end
  end
  
end