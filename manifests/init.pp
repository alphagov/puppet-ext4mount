# == Define: ext4mount
#
# Ensures a specified disk is mounted. Checks that the file system actually exists before trying to mount it and writing the fstab entry
# Only works for ext4 disks.
#
# == Parameters
# [*mountpoint*]
#   Full path to the mount point. This will be created with 'mkdir -p' if it doesn't already exist.
#
# [*disk*]
#   Full path to the disk to mount.
#
# [*mountoptions*]
#   mount options to be added to the fstab line.

#
define ext4mount (
  $mountpoint,
  $disk,
  $mountoptions
) {

  exec { "create-${mountpoint}":
    command => "/bin/mkdir -p ${mountpoint}",
    creates => $mountpoint,
  }

  mount { "mount-${mountpoint}":
    ensure  => mounted,
    name    => $mountpoint,
    device  => $disk,
    fstype  => 'ext4',
    options => $mountoptions,
    require => [Exec["disk-${disk}-exists"],Exec["create-${mountpoint}"]],
  }

  exec { "disk-${disk}-exists":
    command => "/sbin/e2label ${disk}",
    unless  => "/bin/mount | /bin/grep -q ${disk}",
  }
}
