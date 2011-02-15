module Vidibus

  # Rewrite cache buster for assets.
  # To get this solution working, it is required to add some configuration to your apache2 VirtualHost:
  #
  # # Remove timesstamp from versioned static javascripts, stylesheets, and images.
  # # This requires a change in Rails so that assets will be included as image.12345.jpg
  # RewriteEngine on
  # RewriteRule ^/(javascripts|stylesheets|images)/(.+)\.(.+)\.(js|css|jp?g|gif|png)$ /$1/$2.$4 [L]
  #
  # This rewrite does not support SSL. Maybe Apache2 config should be improved...
  #
  module AssetCacheBuster

    # Only works with integer timestamps!
    def asset_file_path(path)
      return super if request.ssl?
      if path.match(/^(.+?)(\.\d+)?(\..+)$/)
        path = "#{$1}#{$3}"
      end
      File.join(config.assets_dir, path)
    end

    def rewrite_asset_path(source, path = nil)
      return super if request.ssl?
      if path && path.respond_to?(:call)
        return path.call(source)
      elsif path && path.is_a?(String)
        return path % [source]
      end

      asset_id = rails_asset_id(source)
      if asset_id.blank?
        source
      else
        source.gsub(/^(.+)(\..+)$/,"\\1.#{asset_id}\\2")
      end
    end
  end
end
