class Url < ActiveRecord::Base
  self.table_name = "urls"

  private

  def validate
    begin
      url = URI.parse(@url)
      invalid_url if url.host is nil
    rescue
      invalid_url
    end
  end

  def invalid_url
    errors.add('Error -- this does not look like a valid URL')
  end
end
