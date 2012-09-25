require 'action_view'
require 'active_support/core_ext/file'
require 'sprockets'

require 'sprockets/rails/asset_host_helper'
require 'sprockets/rails/asset_tag_helper'
require 'sprockets/rails/asset_tag_debug_helper'

module Sprockets
  module Rails
    module Helper
      include AssetHostHelper
      include AssetTagHelper
      include AssetTagDebugHelper

      def compute_asset_path(path, options = {})
        if digest_path = lookup_assets_digest_path(path)
          path = digest_path if digest_assets?
          File.join(assets_prefix || "/", path)
        else
          super
        end
      end

      attr_accessor :digest_assets
      def digest_assets?
        digest_assets.nil? ? false : digest_assets
      end

      attr_accessor :assets_prefix, :assets_environment, :assets_manifest

      protected
        def lookup_assets_digest_path(logical_path)
          if manifest = assets_manifest
            if digest_path = manifest.assets[logical_path]
              return digest_path
            end
          end

          if environment = assets_environment
            if asset = environment[logical_path]
              return asset.digest_path
            end
          end
        end
    end
  end
end