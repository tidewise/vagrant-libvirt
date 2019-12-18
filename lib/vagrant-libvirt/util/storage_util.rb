require 'etc'

module VagrantPlugins
  module ProviderLibvirt
    module Util
      module StorageUtil
        def storage_uid(env)
          if (uid = env[:machine].provider_config.storage_uid)
            resolve_uid(uid)
          elsif env[:machine].provider_config.qemu_use_session
            Process.uid
          else
            0
          end
        end

        def storage_gid(env)
          if (gid = env[:machine].provider_config.storage_gid)
            resolve_gid(gid)
          elsif env[:machine].provider_config.qemu_use_session
            Process.gid
          else
            0
          end
        end

        def resolve_uid(id)
          Integer(id)
        rescue ArgumentError
          Etc.getpwnam(id).uid
        end

        def resolve_gid(id)
          Integer(id)
        rescue ArgumentError
          Etc.getgrnam(id).gid
        end

        def storage_mode(env)
          if (mode = env[:machine].provider_config.storage_mode)
            "0#{Integer(mode).to_s(8)}"
          else
            '0600'
          end
        end

        def storage_pool_path(env)
          if env[:machine].provider_config.storage_pool_path
            env[:machine].provider_config.storage_pool_path
          elsif env[:machine].provider_config.qemu_use_session
            File.expand_path('~/.local/share/libvirt/images')
          else
            '/var/lib/libvirt/images'
          end
        end
      end
    end
  end
end

