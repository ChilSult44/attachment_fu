module Intersect::ImageAttachments
  
  def self.included(included_into)
    
    included_into.module_eval do
      has_many :images, :class_name => "#{self.name}Image"
      after_save :save_attachments

      def attachable_replace=(param)
        @attachment_replace = param
      end

      def attachable=(params)
        @attachments = params.keys.sort.inject([]) { |vals, k| vals.push(params[k]) }.reject {|a| a[:uploaded_data].blank? }.collect { |a| "#{self.class.name}Image".constantize.new(a) }
      end

      protected
      def save_attachments
        if @attachment_replace && @attachments && @attachments.size > 0
          images.destroy_all
        end
        
        if @attachments
          @attachments.each do |attachment|
            images << attachment
          end
        end
      end
      
    end
  end
  
end