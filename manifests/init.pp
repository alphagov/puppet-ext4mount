# == Define: ext4mount
#
# Ensures a specified disk is mounted. Checks that the file system actually exists before trying to mount it and writing the fstab entry
# Only works for ext4 disks.
#
# == Parameters
# [*mountpoint*]
#   Full path to the mount point
#
# [*disk*]
#   Full path to the disk to mount
#
# [*mountoptions*]
#   mount options to be added to the fstab line.

#
define ext4mount (
  $mountpoint,
  $disk,
  $mountoptions = 'errors=remount-ro'
) {

  mount { "mount-${mountpoint}":
    ensure  => mounted,
    name    => $mountpoint,
    device  => $disk,
    fstype  => 'ext4',
    options => $mountoptions,
    require => Exec["disk-${disk}-exists"],
  }

  # yes we know that this has no conditional "onlyif" or similar clause
  # that's because the exec command is already inherently idempotent
  # -- @philandstuff and @rjw1 20130604
  exec { "disk-${disk}-exists":
    command => "/sbin/e2label ${disk}"
  }
}
