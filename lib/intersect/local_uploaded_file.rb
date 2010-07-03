module Intersect
  class LocalUploadedFile
    attr_reader :original_filename

    attr_reader :content_type

    def initialize(path, content_type = 'text/plain')
      raise "#{path} file does not exist" unless File.exist?(path)
      @content_type = content_type
      @original_filename = File.basename(path)
      @tempfile = Tempfile.new(@original_filename)
      FileUtils.copy_file(path, @tempfile.path)
    end

    def path
      @tempfile.path
    end

    alias local_path path

    def method_missing(method_name, *args, &block)
      @tempfile.send(method_name, *args, &block)
    end
  end
end