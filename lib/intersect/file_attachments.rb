module Intersect::FileAttachments
  
  def self.included(included_into)
    
    included_into.module_eval do
      has_many :files, :class_name => "#{self.name}File"
      after_save :save_attachments

      def attachable=(params)
        @attachments = params.keys.sort.inject([]) { |vals, k| vals.push(params[k]) }.reject {|a| a[:uploaded_data].blank? }.collect { |a| "#{self.class.name}File".constantize.new(a) }
      end

      # Currently designed to work with text files only at this time.
      def local_file=(local_file_path)
        file = ActionController::UploadedTempfile.new(File.basename(local_file_path))
        FileUtils.copy_file(local_file_path, file.path)
        file.seek(0)
        content_type = Mime::Type.lookup_by_extension(File.extname(local_file_path)[1..-1])
        @attachments = [
          "#{self.class.name}File".constantize.new(:uploaded_data => Intersect::LocalUploadedFile.new(local_file_path, content_type))
        ]
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