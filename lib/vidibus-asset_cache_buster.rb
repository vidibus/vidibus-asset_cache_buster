require "vidibus/asset_cache_buster"

ActionView::Helpers.module_eval do
  include Vidibus::AssetCacheBuster
end
