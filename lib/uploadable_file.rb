require 'tempfile'
require 'fileutils'
require 'mime/types'

  class UploadableFile
    # The filename, *not* including the path, of the "uploaded" file
    attr_reader :original_filename

    # The content type of the "uploaded" file
    attr_accessor :content_type

    def initialize(path, options = {})
      raise "#{path} file does not exist" unless File.exist?(path)

      if options[:content_type]
        @content_type = options[:content_type]
      else
         mime_types = MIME::Types.type_for(path)
         @content_type = mime_types.empty? ? MIME::Types['text/plain'].first.content_type : mime_types.first.content_type
      end

      @original_filename = path.sub(/^.*#{File::SEPARATOR}([^#{File::SEPARATOR}]+)$/) { $1 }
      @tempfile = Tempfile.new(@original_filename)
      @tempfile.set_encoding(Encoding::BINARY) if @tempfile.respond_to?(:set_encoding)
      @tempfile.binmode if options[:binary]
      FileUtils.copy_file(path, @tempfile.path)
    end

    def path #:nodoc:
      @tempfile.path
    end

    alias local_path path

    def method_missing(method_name, *args, &block) #:nodoc:
      @tempfile.__send__(method_name, *args, &block)
    end
  end