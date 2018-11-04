# frozen_string_literal: true
module Errors
  class BaseError < StandardError
    def code
      self.class.name.demodulize.underscore
    end
  end

  class InvalidUrl < BaseError; end
end
