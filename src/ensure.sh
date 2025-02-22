#!/usr/bin/env sh

ensure() {
    packages="$*"
    echo "Ensure availability of: $packages "
    ROOT_USER_ID=0
    [ "$(id -u)" -ne $ROOT_USER_ID ] && privileges="sudo "

    type apk >/dev/null 2>&1 && echo 'Alpine' \
        && "$privileges"apk add  \
                                --no-cache \
                            $packages 
    type apt >/dev/null 2>&1 && echo 'Debian/Ubuntu' \
        && "$privileges"apt-get update \
        && "$privileges"apt-get install \
                                    --yes \
                                    --no-install-recommends \
                                $packages  \
        && "$privileges"rm -rf /var/lib/apt/lists/*;
    type dnf >/dev/null 2>&1 && echo 'RockyLinux/Centos/Fedora' \
        && dnf upgrade-minimal \
                    --assumeyes \
        && dnf install \
                    --assumeyes \
                $packages  \
        && dnf clean all
    
    echo "Ensure… done"
}