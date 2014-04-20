module Helpers
  def last_segment(uri)
    /([^\/]+$)/.match(uri)[0]
  end
end
