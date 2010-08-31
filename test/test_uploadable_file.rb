require File.expand_path(File.dirname(__FILE__) + "/helper")

class TestUploadableFile < Test::Unit::TestCase

  def setup
    @zip_file_path = File.expand_path(File.dirname(__FILE__) + "/bowling.zip")
    @image_file_path = File.expand_path(File.dirname(__FILE__) + "/dilbert.jpg")
    @text_file_path = File.expand_path(File.dirname(__FILE__) + "/text.txt")
  end

  should "return the original file name" do
    assert_equal "bowling.zip", UploadableFile.new(@zip_file_path).original_filename
  end

  should "raise an Exception if the file does not exist" do
    assert_raise RuntimeError, "/dev/null/foo.txt file does not exist" do
      UploadableFile.new("/dev/null/foo.txt")    
    end
  end
  
  should "set the content type with MIME::Type" do
    assert_equal "application/zip", UploadableFile.new(@zip_file_path).content_type
  end

  should "set manually set the content type if specified in the options" do
    assert_equal "imaginary/content_type", UploadableFile.new(@zip_file_path, :content_type => "imaginary/content_type").content_type
  end

  should "set the encoding to binary if file responds to set_encoding" do
    assert_equal "imaginary/content_type", UploadableFile.new(@zip_file_path, :content_type => "imaginary/content_type").content_type
  end

  should "copy the file to the tempfile path" do
    assert File.exists?(UploadableFile.new(@zip_file_path).path)
  end

end
