class Url < ActiveRecord::Base
  self.table_name = "urls"

  before_create :validate


  def self.lookup(full_url)
    short_url = Base64.encode64(Digest::SHA256.hexdigest(full_url)).first(8)

    url = find_or_create_by(full_url: full_url).tap do |url|
      url.short_url ||= short_url
    end
    url.save!
    url
  end

  def self.lookup_by_short_url(short_url)
    url = Url.where(short_url: short_url)

    raise Errors::InvalidUrl if url.empty?

    full_url = url.first.full_url
    full_url.starts_with?('http') ? full_url : "http://#{full_url}"
  end


  def validate
    raise Errors::InvalidUrl unless full_url.include?('.')
  end
end
